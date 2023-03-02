//
//  KindKit
//

import Foundation

public extension Api.Flow {
    
    final class Query<
        Input : IFlowResult,
        Success,
        Failure : Swift.Error,
        Response : IApiResponse
    > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _provider: Api.Provider
        private let _queue: DispatchQueue
        private let _request: (Input.Success) throws -> Api.Request?
        private let _response: (Input.Success) -> Response
        private let _validation: ((Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation)?
        private let _success: (Input.Success, Response.Success) -> Success
        private let _failure: (Input.Success, Response.Failure) -> Failure
        private var _task: ICancellable? {
            willSet {
                self._task?.cancel()
            }
        }
        private var _next: IFlowPipe!
        
        init(
            _ provider: Api.Provider,
            _ dispatch: Flow.Operator.DispatchMode,
            _ request: @escaping (Input.Success) throws -> Api.Request?,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: ((Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation)?,
            _ success: @escaping (Input.Success, Response.Success) -> Success,
            _ failure: @escaping (Input.Success, Response.Failure) -> Failure
        ) {
            self._provider = provider
            self._queue = dispatch.queue
            self._request = request
            self._response = response
            self._validation = validation
            self._success = success
            self._failure = failure
        }
        
        convenience init(
            _ provider: Api.Provider,
            _ dispatch: Flow.Operator.DispatchMode,
            _ request: @escaping (Input.Success) throws -> Api.Request?,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: ((Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation)?,
            _ success: @escaping (Input.Success, Response.Success) -> Success
        ) where
            Failure == Response.Failure
        {
            self.init(provider, dispatch, request, response, validation, success, { _, error in error })
        }
        
        convenience init(
            _ provider: Api.Provider,
            _ dispatch: Flow.Operator.DispatchMode,
            _ request: @escaping (Input.Success) throws -> Api.Request?,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: ((Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation)?,
            _ failure: @escaping (Input.Success, Response.Result.Failure) -> Failure
        ) where
            Success == Response.Success
        {
            self.init(provider, dispatch, request, response, validation, { _, value in value }, failure)
        }
        
        convenience init(
            _ provider: Api.Provider,
            _ dispatch: Flow.Operator.DispatchMode,
            _ request: @escaping (Input.Success) throws -> Api.Request?,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: ((Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation)?
        ) where
            Success == Response.Success,
            Failure == Response.Failure
        {
            self.init(provider, dispatch, request, response, validation, { _, value in value }, { _, error in error })
        }
        
        deinit {
            self._cancel()
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._cancel()
            self._run(Date(), value)
        }
        
        public func receive(error: Input.Failure) {
            self._cancel()
            self._next.send(error: error)
            self._next.completed()
        }
        
        public func completed() {
        }
        
        public func cancel() {
            self._task?.cancel()
            self._next.cancel()
        }
        
    }
    
}

private extension Api.Flow.Query {
    
    func _cancel() {
        self._task = nil
    }
    
    func _run(
        _ startedAt: Date,
        _ input: Input.Success
    ) {
        self._task = self._provider.send(
            request: try self._request(input),
            response: self._response(input),
            queue: self._queue,
            completed: { [weak self] in self?._completed(startedAt, input, $0) }
        )
    }

    func _completed(
        _ startedAt: Date,
        _ input: Input.Success,
        _ output: Response.Result
    ) {
        self._task = nil
        let elapsed = Date().timeIntervalSince(startedAt)
        switch self._validation?(input, output, elapsed) {
        case .retry(let delay):
            self._task = DispatchWorkItem.kk_async(
                queue: self._queue,
                delay: delay,
                block: { [weak self] in
                    self?._run(startedAt, input)
                }
            )
        case .done, .none:
            switch output {
            case .success(let value):
                self._next.send(value: self._success(input, value))
                self._next.completed()
            case .failure(let error):
                self._next.send(error: self._failure(input, error))
                self._next.completed()
            }
        }
    }
    
}

extension IFlowOperator {
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        _ provider: Api.Provider,
        _ dispatch: Flow.Operator.DispatchMode,
        _ request: @escaping (Output.Success) throws -> Api.Request?,
        _ response: @escaping (Output.Success) -> Response,
        _ validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        _ success: @escaping (Output.Success, Response.Success) -> Success,
        _ failure: @escaping (Output.Success, Response.Failure) -> Failure
    ) -> Api.Flow.Query< Output, Success, Failure, Response > where
        Output.Failure == Failure
    {
        let next = Api.Flow.Query< Output, Success, Failure, Response >(provider, dispatch, request, response, validation, success, failure)
        self.subscribe(next: next)
        return next
    }
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        _ provider: Api.Provider,
        _ dispatch: Flow.Operator.DispatchMode,
        _ request: @escaping (Output.Success) throws -> Api.Request?,
        _ response: @escaping (Output.Success) -> Response,
        _ validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        _ success: @escaping (Output.Success, Response.Success) -> Success
    ) -> Api.Flow.Query< Output, Success, Response.Failure, Response > where
        Output.Failure == Response.Failure
    {
        let next = Api.Flow.Query< Output, Success, Response.Failure, Response >(provider, dispatch, request, response, validation, success)
        self.subscribe(next: next)
        return next
    }
    
    func apiQuery<
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        _ provider: Api.Provider,
        _ dispatch: Flow.Operator.DispatchMode,
        _ request: @escaping (Output.Success) throws -> Api.Request?,
        _ response: @escaping (Output.Success) -> Response,
        _ validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        _ failure: @escaping (Output.Success, Response.Failure) -> Failure
    ) -> Api.Flow.Query< Output, Response.Success, Failure, Response > where
        Output.Failure == Failure
    {
        let next = Api.Flow.Query< Output, Response.Success, Failure, Response >(provider, dispatch, request, response, validation, failure)
        self.subscribe(next: next)
        return next
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        _ provider: Api.Provider,
        _ dispatch: Flow.Operator.DispatchMode,
        _ request: @escaping (Output.Success) throws -> Api.Request?,
        _ response: @escaping (Output.Success) -> Response,
        _ validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Api.Flow.Query< Output, Response.Success, Response.Failure, Response > where
        Output.Failure == Response.Failure
    {
        let next = Api.Flow.Query< Output, Response.Success, Response.Failure, Response >(provider, dispatch, request, response, validation)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow.Builder {
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        success: @escaping (Input.Success, Response.Success) -> Success,
        failure: @escaping (Input.Success, Response.Failure) -> Failure
    ) -> Flow.Head.Builder< Api.Flow.Query< Input, Success, Input.Failure, Response > > {
        return .init(head: .init(provider, dispatch, request, response, validation, success, failure))
    }
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        success: @escaping (Input.Success, Response.Success) -> Success
    ) -> Flow.Head.Builder< Api.Flow.Query< Input, Success, Response.Failure, Response > > where
        Input.Failure == Response.Failure
    {
        return .init(head: .init(provider, dispatch, request, response, validation, success))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        failure: @escaping (Input.Success, Response.Failure) -> Input.Failure
    ) -> Flow.Head.Builder< Api.Flow.Query< Input, Response.Success, Input.Failure, Response > > {
        return .init(head: .init(provider, dispatch, request, response, validation, failure))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Flow.Head.Builder< Api.Flow.Query< Input, Response.Success, Response.Failure, Response > > where
        Input.Failure == Response.Failure
    {
        return .init(head: .init(provider, dispatch, request, response, validation))
    }
    
}

public extension Flow.Head.Builder {
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        success: @escaping (Head.Output.Success, Response.Success) -> Success,
        failure: @escaping (Head.Output.Success, Response.Failure) -> Failure
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Head.Output, Success, Failure, Response > > where
        Head.Output.Failure == Failure
    {
        return .init(head: self.head, tail: self.head.apiQuery(provider, dispatch, request, response, validation, success, failure))
    }
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        success: @escaping (Head.Output.Success, Response.Success) -> Success
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Head.Output, Success, Response.Failure, Response > > where
        Head.Output.Failure == Response.Failure
    {
        return .init(head: self.head, tail: self.head.apiQuery(provider, dispatch, request, response, validation, success))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        failure: @escaping (Head.Output.Success, Response.Failure) -> Head.Output.Failure
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Head.Output, Response.Success, Head.Output.Failure, Response > > {
        return .init(head: self.head, tail: self.head.apiQuery(provider, dispatch, request, response, validation, failure))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Head.Output, Response.Success, Response.Failure, Response > > where
        Head.Output.Failure == Response.Failure
    {
        return .init(head: self.head, tail: self.head.apiQuery(provider, dispatch, request, response, validation))
    }
    
}

public extension Flow.Chain.Builder {
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        success: @escaping (Tail.Output.Success, Response.Success) -> Success,
        failure: @escaping (Tail.Output.Success, Response.Failure) -> Failure
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Tail.Output, Success, Failure, Response > > where
        Tail.Output.Failure == Failure
    {
        return .init(head: self.head, tail: self.tail.apiQuery(provider, dispatch, request, response, validation, success, failure))
    }
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        success: @escaping (Tail.Output.Success, Response.Success) -> Success
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Tail.Output, Success, Response.Failure, Response > > where
        Tail.Output.Failure == Response.Failure
    {
        return .init(head: self.head, tail: self.tail.apiQuery(provider, dispatch, request, response, validation, success))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        failure: @escaping (Tail.Output.Success, Response.Failure) -> Tail.Output.Failure
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Tail.Output, Response.Success, Tail.Output.Failure, Response > > {
        return .init(head: self.head, tail: self.tail.apiQuery(provider, dispatch, request, response, validation, failure))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        dispatch: Flow.Operator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Flow.Chain.Builder< Head, Api.Flow.Query< Tail.Output, Response.Success, Response.Failure, Response > > where
        Tail.Output.Failure == Response.Failure
    {
        return .init(head: self.head, tail: self.tail.apiQuery(provider, dispatch, request, response, validation))
    }
    
}
