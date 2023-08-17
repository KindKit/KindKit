//
//  KindKit
//

import Foundation

public extension RemoteImage.Flow {

    final class Download<
        Input : IFlowResult,
        Success,
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _loader: RemoteImage.Loader
        private let _query: (Input.Success) -> Query
        private let _filter: (Input.Success) -> IRemoteImageFilter?
        private let _validation: (Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation
        private let _logging: (Input.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage?
        private let _map: (Input.Success, Result< UI.Image, RemoteImage.Error >) -> Result< Success, Failure >
        private var _state: State?
        private var _task: ICancellable? {
            willSet {
                self._task?.cancel()
            }
        }
        private var _next: IFlowPipe!
        
        init(
            _ loader: RemoteImage.Loader,
            _ query: @escaping (Input.Success) -> Query,
            _ filter: @escaping (Input.Success) -> IRemoteImageFilter?,
            _ validation: @escaping (Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation,
            _ logging: @escaping (Input.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage?,
            _ map: @escaping (Input.Success, Result< UI.Image, RemoteImage.Error >) -> Result< Success, Failure >
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
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._task?.cancel()
            self._run(.init(startedAt: Date(), input: value))
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
    
}

private extension RemoteImage.Flow.Download {
    
    struct State {
        
        let startedAt: Date
        let input: Input.Success

    }
    
}

private extension RemoteImage.Flow.Download {
    
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
        _ output: Result< UI.Image, RemoteImage.Error >
    ) {
        let elapsed = Date().timeIntervalSince(state.startedAt)
        switch self._validation(state.input, output, elapsed) {
        case .retry(let delay):
            self._task = DispatchWorkItem.kk_async(
                queue: self._loader.syncQueue,
                delay: delay,
                block: { [weak self] in
                    self?._run(state)
                }
            )
        case .done:
            self._task = nil
            if let message = self._logging(state.input,output) {
                Log.shared.log(message: message)
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

extension RemoteImage.Flow.Download : IRemoteImageTarget {
    
    public func remoteImage(progress: Double) {
    }
    
    public func remoteImage(image: UI.Image) {
        guard let state = self._state else { return }
        self._completed(state, .success(image))
    }
    
    public func remoteImage(error: RemoteImage.Error) {
        guard let state = self._state else { return }
        self._completed(state, .failure(error))
    }
    
}

public extension IFlowBuilder {
    
    func download<
        Success,
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil },
        map: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> Result< Success, Failure >
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, Success, Failure, Query > > {
        return self.append(.init(loader, query, filter, validation, logging, map))
    }
    
    func download<
        Success,
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil },
        success: @escaping (Tail.Output.Success, UI.Image) -> Success,
        failure: @escaping (Tail.Output.Success, RemoteImage.Error) -> Failure
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, Success, Failure, Query > > {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< Success, Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil },
        success: @escaping (Tail.Output.Success, UI.Image) -> Success
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, Success, RemoteImage.Error, Query > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< Success, RemoteImage.Error > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil },
        success: @escaping (Tail.Output.Success, UI.Image) -> Success
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, Success, RemoteImage.Error, Query > > where
        Tail.Output.Failure == RemoteImage.Error
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< Success, RemoteImage.Error > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func download<
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil },
        failure: @escaping (Tail.Output.Success, RemoteImage.Error) -> Failure
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, UI.Image, Failure, Query > > {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< UI.Image, Failure > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil }
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, UI.Image, RemoteImage.Error, Query > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< UI.Image, RemoteImage.Error > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: @escaping (Tail.Output.Success) -> IRemoteImageFilter? = { _ in nil },
        validation: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Result< UI.Image, RemoteImage.Error >) -> ILogMessage? = { _, _ in nil }
    ) -> Flow.Chain< Head, RemoteImage.Flow.Download< Tail.Output, UI.Image, RemoteImage.Error, Query > > where
        Tail.Output.Failure == RemoteImage.Error
    {
        return self.append(.init(loader, query, filter, validation, logging, { input, result -> Result< UI.Image, RemoteImage.Error > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
}
