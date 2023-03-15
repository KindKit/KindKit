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
        private let _filter: ((Input.Success) -> IRemoteImageFilter)?
        private let _validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?
        private let _success: (Input.Success, UI.Image) -> Success
        private let _failure: (Input.Success, RemoteImage.Error) -> Failure
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
            _ filter: ((Input.Success) -> IRemoteImageFilter)?,
            _ validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?,
            _ success: @escaping (Input.Success, UI.Image) -> Success,
            _ failure: @escaping (Input.Success, RemoteImage.Error) -> Failure
        ) {
            self._loader = loader
            self._query = query
            self._filter = filter
            self._validation = validation
            self._success = success
            self._failure = failure
        }
        
        convenience init(
            _ loader: RemoteImage.Loader,
            _ query: @escaping (Input.Success) -> Query,
            _ filter: ((Input.Success) -> IRemoteImageFilter)?,
            _ validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?,
            _ success: @escaping (Input.Success, UI.Image) -> Success
        ) where
            Failure == RemoteImage.Error
        {
            self.init(loader, query, filter, validation, success, { _, error in error })
        }
        
        convenience init(
            _ loader: RemoteImage.Loader,
            _ query: @escaping (Input.Success) -> Query,
            _ filter: ((Input.Success) -> IRemoteImageFilter)?,
            _ validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?,
            _ failure: @escaping (Input.Success, RemoteImage.Error) -> Failure
        ) where
            Success == UI.Image
        {
            self.init(loader, query, filter, validation, { _, value in value }, failure)
        }
        
        convenience init(
            _ loader: RemoteImage.Loader,
            _ query: @escaping (Input.Success) -> Query,
            _ filter: ((Input.Success) -> IRemoteImageFilter)?,
            _ validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?
        ) where
            Success == UI.Image,
            Failure == RemoteImage.Error
        {
            self.init(loader, query, filter, validation, { _, value in value }, { _, error in error })
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
            filter: self._filter?(state.input)
        )
    }

    func _completed(
        _ state: State,
        _ output: Result< UI.Image, RemoteImage.Error >
    ) {
        let elapsed = Date().timeIntervalSince(state.startedAt)
        switch self._validation?(state.input, output, elapsed) {
        case .retry(let delay):
            self._task = DispatchWorkItem.kk_async(
                queue: self._loader.syncQueue,
                delay: delay,
                block: { [weak self] in
                    self?._run(state)
                }
            )
        case .done, .none:
            self._task = nil
            switch output {
            case .success(let value):
                self._next.send(value: self._success(state.input, value))
                self._next.completed()
            case .failure(let error):
                self._next.send(error: self._failure(state.input, error))
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

extension IFlowOperator {
    
    func download<
        Success,
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        _ loader: RemoteImage.Loader,
        _ query: @escaping (Output.Success) -> Query,
        _ filter: ((Output.Success) -> IRemoteImageFilter)?,
        _ validation: ((Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?,
        _ success: @escaping (Output.Success, UI.Image) -> Success,
        _ failure: @escaping (Output.Success, RemoteImage.Error) -> Failure
    ) -> RemoteImage.Flow.Download< Output, Success, Failure, Query > where
        Output.Failure == Failure
    {
        let next = RemoteImage.Flow.Download< Output, Success, Failure, Query >(loader, query, filter, validation, success, failure)
        self.subscribe(next: next)
        return next
    }
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        _ loader: RemoteImage.Loader,
        _ query: @escaping (Output.Success) -> Query,
        _ filter: ((Output.Success) -> IRemoteImageFilter)?,
        _ validation: ((Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?,
        _ success: @escaping (Output.Success, UI.Image) -> Success
    ) -> RemoteImage.Flow.Download< Output, Success, RemoteImage.Error, Query > where
        Output.Failure == RemoteImage.Error
    {
        let next = RemoteImage.Flow.Download< Output, Success, RemoteImage.Error, Query >(loader, query, filter, validation, success)
        self.subscribe(next: next)
        return next
    }
    
    func download<
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        _ loader: RemoteImage.Loader,
        _ query: @escaping (Output.Success) -> Query,
        _ filter: ((Output.Success) -> IRemoteImageFilter)?,
        _ validation: ((Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?,
        _ failure: @escaping (Output.Success, RemoteImage.Error) -> Failure
    ) -> RemoteImage.Flow.Download< Output, UI.Image, Failure, Query > where
        Output.Failure == Failure
    {
        let next = RemoteImage.Flow.Download< Output, UI.Image, Failure, Query >(loader, query, filter, validation, failure)
        self.subscribe(next: next)
        return next
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        _ loader: RemoteImage.Loader,
        _ query: @escaping (Output.Success) -> Query,
        _ filter: ((Output.Success) -> IRemoteImageFilter)?,
        _ validation: ((Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)?
    ) -> RemoteImage.Flow.Download< Output, UI.Image, RemoteImage.Error, Query > where
        Output.Failure == RemoteImage.Error
    {
        let next = RemoteImage.Flow.Download< Output, UI.Image, RemoteImage.Error, Query >(loader, query, filter, validation)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Input.Success) -> Query,
        filter: ((Input.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        success: @escaping (Input.Success, UI.Image) -> Success,
        failure: @escaping (Input.Success, RemoteImage.Error) -> Failure
    ) -> Flow.Head.Builder< RemoteImage.Flow.Download< Input, Success, Input.Failure, Query > > {
        return .init(head: .init(loader, query, filter, validation, success, failure))
    }
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Input.Success) -> Query,
        filter: ((Input.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        success: @escaping (Input.Success, UI.Image) -> Success
    ) -> Flow.Head.Builder< RemoteImage.Flow.Download< Input, Success, RemoteImage.Error, Query > > where
        Input.Failure == RemoteImage.Error
    {
        return .init(head: .init(loader, query, filter, validation, success))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Input.Success) -> Query,
        filter: ((Input.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        failure: @escaping (Input.Success, RemoteImage.Error) -> Failure
    ) -> Flow.Head.Builder< RemoteImage.Flow.Download< Input, UI.Image, Input.Failure, Query > > {
        return .init(head: .init(loader, query, filter, validation, failure))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Input.Success) -> Query,
        filter: ((Input.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Input.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil
    ) -> Flow.Head.Builder< RemoteImage.Flow.Download< Input, UI.Image, RemoteImage.Error, Query > > where
        Input.Failure == RemoteImage.Error
    {
        return .init(head: .init(loader, query, filter, validation))
    }
    
}

public extension Flow.Head.Builder {
    
    func download<
        Success,
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Head.Output.Success) -> Query,
        filter: ((Head.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Head.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        success: @escaping (Head.Output.Success, UI.Image) -> Success,
        failure: @escaping (Head.Output.Success, RemoteImage.Error) -> Failure
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Head.Output, Success, Failure, Query > > where
        Head.Output.Failure == Failure
    {
        return .init(head: self.head, tail: self.head.download(loader, query, filter, validation, success, failure))
    }
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Head.Output.Success) -> Query,
        filter: ((Head.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Head.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        success: @escaping (Head.Output.Success, UI.Image) -> Success
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Head.Output, Success, RemoteImage.Error, Query > > where
        Head.Output.Failure == RemoteImage.Error
    {
        return .init(head: self.head, tail: self.head.download(loader, query, filter, validation, success))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Head.Output.Success) -> Query,
        filter: ((Head.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Head.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        failure: @escaping (Head.Output.Success, RemoteImage.Error) -> Head.Output.Failure
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Head.Output, UI.Image, Head.Output.Failure, Query > > {
        return .init(head: self.head, tail: self.head.download(loader, query, filter, validation, failure))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Head.Output.Success) -> Query,
        filter: ((Head.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Head.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Head.Output, UI.Image, RemoteImage.Error, Query > > where
        Head.Output.Failure == RemoteImage.Error
    {
        return .init(head: self.head, tail: self.head.download(loader, query, filter, validation))
    }
    
}

public extension Flow.Chain.Builder {
    
    func download<
        Success,
        Failure : Swift.Error,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: ((Tail.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        success: @escaping (Tail.Output.Success, UI.Image) -> Success,
        failure: @escaping (Tail.Output.Success, RemoteImage.Error) -> Failure
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Tail.Output, Success, Failure, Query > > where
        Tail.Output.Failure == Failure
    {
        return .init(head: self.head, tail: self.tail.download(loader, query, filter, validation, success, failure))
    }
    
    func download<
        Success,
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: ((Tail.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        success: @escaping (Tail.Output.Success, UI.Image) -> Success
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Tail.Output, Success, RemoteImage.Error, Query > > where
        Tail.Output.Failure == RemoteImage.Error
    {
        return .init(head: self.head, tail: self.tail.download(loader, query, filter, validation, success))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: ((Tail.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil,
        failure: @escaping (Tail.Output.Success, RemoteImage.Error) -> Tail.Output.Failure
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Tail.Output, UI.Image, Tail.Output.Failure, Query > > {
        return .init(head: self.head, tail: self.tail.download(loader, query, filter, validation, failure))
    }
    
    func download<
        Query : IRemoteImageQuery
    >(
        loader: RemoteImage.Loader = .shared,
        query: @escaping (Tail.Output.Success) -> Query,
        filter: ((Tail.Output.Success) -> IRemoteImageFilter)? = nil,
        validation: ((Tail.Output.Success, Result< UI.Image, RemoteImage.Error >, TimeInterval) -> Flow.Validation)? = nil
    ) -> Flow.Chain.Builder< Head, RemoteImage.Flow.Download< Tail.Output, UI.Image, RemoteImage.Error, Query > > where
        Tail.Output.Failure == RemoteImage.Error
    {
        return .init(head: self.head, tail: self.tail.download(loader, query, filter,  validation))
    }
    
}
