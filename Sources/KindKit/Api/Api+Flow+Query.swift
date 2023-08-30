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
        private let _request: (Input.Success) throws -> Api.Request
        private let _response: (Input.Success) -> Response
        private let _validation: (Input.Success, Response.Result, TimeInterval) -> Flow.Validation
        private let _logging: (Input.Success, Response.Result, TimeInterval) -> ILogMessage?
        private let _map: (Input.Success, Response.Result) -> Result< Success, Failure >
        private var _task: ICancellable? {
            willSet {
                self._task?.cancel()
            }
        }
        private var _next: IFlowPipe!
        
        init(
            _ provider: Api.Provider,
            _ queue: DispatchQueue,
            _ request: @escaping (Input.Success) throws -> Api.Request,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Flow.Validation,
            _ logging: @escaping (Input.Success, Response.Result, TimeInterval) -> ILogMessage?,
            _ map: @escaping (Input.Success, Response.Result) -> Result< Success, Failure >
        ) {
            self._provider = provider
            self._queue = queue
            self._request = request
            self._response = response
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
        switch self._validation(input, output, elapsed) {
        case .retry(let delay):
            self._task = DispatchWorkItem.kk_async(
                queue: self._queue,
                delay: delay,
                block: { [weak self] in
                    self?._run(startedAt, input)
                }
            )
        case .done:
            if let message = self._logging(input, output, elapsed) {
                Log.shared.log(message: message)
            }
            self._task = nil
            switch self._map(input, output) {
            case .success(let value):
                self._next.send(value: value)
            case .failure(let error):
                self._next.send(error: error)
            }
            self._next.completed()
        }
    }
    
}

public extension IFlowBuilder {
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil },
        map: @escaping (Tail.Output.Success, Response.Result) -> Result< Success, Failure >
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Success, Failure, Response > > {
        return self.append(.init(provider, queue, request, response, validation, logging, map))
    }
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil },
        success: @escaping (Tail.Output.Success, Response.Success) -> Success,
        failure: @escaping (Tail.Output.Success, Response.Failure) -> Failure
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Success, Failure, Response > > {
        return self.append(.init(provider, queue, request, response, validation, logging, { input, result -> Result< Success, Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil },
        success: @escaping (Tail.Output.Success, Response.Success) -> Success
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Success, Response.Failure, Response > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(provider, queue, request, response, validation, logging, { input, result -> Result< Success, Response.Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func apiQuery<
        Success,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil },
        success: @escaping (Tail.Output.Success, Response.Success) -> Success
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Success, Response.Failure, Response > > where
        Tail.Output.Failure == Response.Failure
    {
        return self.append(.init(provider, queue, request, response, validation, logging, { input, result -> Result< Success, Response.Failure > in
            switch result {
            case .success(let value): return .success(success(input, value))
            case .failure(let error): return .failure(error)
            }
        }))
    }
    
    func apiQuery<
        Failure : Swift.Error,
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil },
        failure: @escaping (Tail.Output.Success, Response.Failure) -> Failure
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Response.Success, Failure, Response > > {
        return self.append(.init(provider, queue, request, response, validation, logging, { input, result -> Result< Response.Success, Failure > in
            switch result {
            case .success(let value): return .success(value)
            case .failure(let error): return .failure(failure(input, error))
            }
        }))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil }
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Response.Success, Response.Failure, Response > > where
        Tail.Output.Failure == Never
    {
        return self.append(.init(provider, queue, request, response, validation, logging, { input, result -> Response.Result in
            return result
        }))
    }
    
    func apiQuery<
        Response : IApiResponse
    >(
        provider: Api.Provider,
        queue: DispatchQueue,
        request: @escaping (Tail.Output.Success) throws -> Api.Request,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Flow.Validation = { _, _, _ in .done },
        logging: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> ILogMessage? = { _, _, _ in nil }
    ) -> Flow.Chain< Head, Api.Flow.Query< Tail.Output, Response.Success, Response.Failure, Response > > where
        Tail.Output.Failure == Response.Failure
    {
        return self.append(.init(provider, queue, request, response, validation, logging, { input, result -> Response.Result in
            return result
        }))
    }
    
}
