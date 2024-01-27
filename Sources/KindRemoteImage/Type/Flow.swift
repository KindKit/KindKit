//
//  KindKit
//

import Foundation
import KindFlow
import KindGraphics
import KindLog
import KindTime

public final class Flow<
    InputType : IResult,
    SuccessType,
    FailureType : Swift.Error,
    QueryType : IQuery
> : IOperator {
    
    public typealias Input = InputType
    public typealias Output = Result< SuccessType, FailureType >
    
    private let _loader: Loader
    private let _query: (Input.Success) -> QueryType
    private let _filter: (Input.Success) -> IFilter?
    private let _validation: (Input.Success, Result< Image, Error >, SecondsInterval) -> Validation
    private let _logging: (Input.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage?
    private let _map: (Input.Success, Result< Image, Error >) -> Result< SuccessType, FailureType >
    private var _state: State?
    private var _task: ICancellable? {
        willSet {
            self._task?.cancel()
        }
    }
    private var _next: IPipe!
    
    init(
        _ loader: Loader,
        _ query: @escaping (Input.Success) -> QueryType,
        _ filter: @escaping (Input.Success) -> IFilter?,
        _ validation: @escaping (Input.Success, Result< Image, Error >, SecondsInterval) -> Validation,
        _ logging: @escaping (Input.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage?,
        _ map: @escaping (Input.Success, Result< Image, Error >) -> Result< SuccessType, FailureType >
    ) {
        self._loader = loader
        self._query = query
        self._filter = filter
        self._validation = validation
        self._logging = logging
        self._map = map
    }
    
    deinit {
        self._cancel()
    }
    
    public func subscribe(next: IPipe) {
        self._next = next
    }
    
    public func receive(value: Input.Success) {
        self._task?.cancel()
        self._run(.init(startedAt: .now, input: value))
    }
    
    public func receive(error: Input.Failure) {
        self._cancel()
        self._next.send(error: error)
        self._next.completed()
    }
    
    public func completed() {
    }
    
    public func cancel() {
        self._cancel()
        self._next.cancel()
    }
    
}

private extension Flow {
    
    struct State {
        
        let startedAt: SecondsInterval
        let input: Input.Success

    }
    
}

private extension Flow {
    
    func _cancel() {
        self._task = nil
        self._loader.cancel(target: self)
    }
    
    func _run(
        _ state: State
    ) {
        self._state = state
        self._loader.download(
            target: self,
            query: self._query(state.input),
            filter: self._filter(state.input)
        )
    }

    func _completed(
        _ state: State,
        _ output: Result< Image, Error >
    ) {
        let elapsed = state.startedAt.delta(to: .now)
        switch self._validation(state.input, output, elapsed) {
        case .retry(let delay):
            self._task = DispatchWorkItem.async(
                queue: self._loader.syncQueue,
                delay: delay,
                block: { [weak self] in
                    self?._run(state)
                }
            )
        case .done:
            self._task = nil
            if let message = self._logging(state.input, output, elapsed) {
                KindLog.default.log(message: message)
            }
            switch self._map(state.input, output) {
            case .success(let value):
                self._next.send(value: value)
                self._next.completed()
            case .failure(let error):
                self._next.send(error: error)
                self._next.completed()
            }
        }
    }
    
}

extension Flow : ITarget {
    
    public func remoteImage(progress: Double) {
    }
    
    public func remoteImage(image: Image) {
        guard let state = self._state else { return }
        self._completed(state, .success(image))
    }
    
    public func remoteImage(error: Error) {
        guard let state = self._state else { return }
        self._completed(state, .failure(error))
    }
    
}

public extension IBuilder {
    
    func remoteImage<
        SuccessType,
        FailureType : Swift.Error,
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil },
        map: @escaping (Tail.Output.Success, Result< Image, Error >) -> Result< SuccessType, FailureType >
    ) -> Chain< Head, Flow< Tail.Output, SuccessType, FailureType, QueryType > > {
        return self.append(.init(loader, query, filter, validation, logging, map))
    }
    
    func remoteImage<
        SuccessType,
        FailureType : Swift.Error,
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil },
        success: @escaping (Tail.Output.Success, Image) -> SuccessType,
        failure: @escaping (Tail.Output.Success, Error) -> FailureType
    ) -> Chain< Head, Flow< Tail.Output, SuccessType, FailureType, QueryType > > {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< SuccessType, FailureType > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func remoteImage<
        SuccessType,
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil },
        success: @escaping (Tail.Output.Success, Image) -> SuccessType
    ) -> Chain< Head, Flow< Tail.Output, SuccessType, Error, QueryType > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< SuccessType, Error > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func remoteImage<
        SuccessType,
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil },
        success: @escaping (Tail.Output.Success, Image) -> SuccessType
    ) -> Chain< Head, Flow< Tail.Output, SuccessType, Error, QueryType > > where
        Tail.Output.Failure == Error
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< SuccessType, Error > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func remoteImage<
        FailureType : Swift.Error,
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil },
        failure: @escaping (Tail.Output.Success, Error) -> FailureType
    ) -> Chain< Head, Flow< Tail.Output, Image, FailureType, QueryType > > {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< Image, FailureType > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func remoteImage<
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil }
    ) -> Chain< Head, Flow< Tail.Output, Image, Error, QueryType > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< Image, Error > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func remoteImage<
        QueryType : IQuery
    >(
        loader: Loader = .shared,
        query: @escaping (Tail.Output.Success) -> QueryType,
        filter: @escaping (Tail.Output.Success) -> IFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< Image, Error >, SecondsInterval) -> KindLog.IMessage? = { _, _, _ in nil }
    ) -> Chain< Head, Flow< Tail.Output, Image, Error, QueryType > > where
        Tail.Output.Failure == Error
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< Image, Error > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
}
