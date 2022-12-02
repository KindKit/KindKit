//
//  KindKit
//

import Foundation

public extension Api.Flow {
    
    final class Query< Input : IFlowResult, Provider : IApiProvider, Response : IApiResponse, Success > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Response.Failure >
        
        private let _provider: Provider
        private let _queue: DispatchQueue
        private let _request: (Input.Success) throws -> Api.Request?
        private let _response: (Input.Success) -> Response
        private let _validation: (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation
        private let _map: (Input.Success, Response.Result.Success) -> Success
        private var _task: ICancellable?
        private var _next: IFlowPipe!
        
        init(
            _ provider: Provider,
            _ dispatch: FlowOperator.DispatchMode,
            _ request: @escaping (Input.Success) throws -> Api.Request?,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation,
            _ map: @escaping (Input.Success, Response.Result.Success) -> Success
        ) {
            self._provider = provider
            self._queue = dispatch.queue
            self._request = request
            self._response = response
            self._validation = validation
            self._map = map
        }
        
        deinit {
            if let query = self._task {
                query.cancel()
            }
        }
        
        public func subscribe(next: IFlowPipe) {
            self._next = next
        }
        
        public func receive(value: Input.Success) {
            self._task?.cancel()
            self._run(Date(), value)
        }
        
        public func receive(error: Input.Failure) {
            self._task?.cancel()
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
    
    func _run(
        _ date: Date,
        _ input: Input.Success
    ) {
        self._task = self._provider.send(
            request: try self._request(input),
            response: self._response(input),
            queue: self._queue,
            completed: { [weak self] in self?._completed(date, input, $0) }
        )
    }

    func _completed(
        _ date: Date,
        _ input: Input.Success,
        _ output: Result< Response.Success, Response.Failure >
    ) {
        self._task = nil
        let elapsed = Date().timeIntervalSince(date)
        switch self._validation(input, output, elapsed) {
        case .retry(let delay):
            self._task = DispatchWorkItem.kk_async(
                block: { [weak self] in
                    self?._run(date, input)
                },
                queue: self._queue,
                delay: delay
            )
        case .done:
            switch output {
            case .success(let value):
                self._next.send(value: self._map(input, value))
                self._next.completed()
            case .failure(let error):
                self._next.send(error: error)
                self._next.completed()
            }
        }
    }
    
}

extension IFlowOperator {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Output.Success) throws -> Api.Request?,
        response: @escaping (Output.Success) -> Response,
        validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Api.Flow.Query< Output, Provider, Response, Response.Success > {
        let next = Api.Flow.Query< Output, Provider, Response, Response.Success >(provider, dispatch, request, response, validation, { _, response in response })
        self.subscribe(next: next)
        return next
    }
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse,
        Success
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Output.Success) throws -> Api.Request?,
        response: @escaping (Output.Success) -> Response,
        validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        map: @escaping (Output.Success, Response.Result.Success) -> Success
    ) -> Api.Flow.Query< Output, Provider, Response, Success > {
        let next = Api.Flow.Query< Output, Provider, Response, Success >(provider, dispatch, request, response, validation, map)
        self.subscribe(next: next)
        return next
    }
    
}

public extension Flow {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> FlowBuilder.Head< Api.Flow.Query< Input, Provider, Response, Response.Success > > {
        return .init(head: .init(provider, dispatch, request, response, validation, { _, response in response }))
    }
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse,
        Success
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        map: @escaping (Input.Success, Response.Result.Success) -> Success
    ) -> FlowBuilder.Head< Api.Flow.Query< Input, Provider, Response, Success > > {
        return .init(head: .init(provider, dispatch, request, response, validation, map))
    }
    
}

public extension FlowBuilder.Head {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> FlowBuilder.Chain< Head, Api.Flow.Query< Head.Output, Provider, Response, Response.Success > > {
        return .init(head: self.head, tail: self.head.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation))
    }
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse,
        Success
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        map: @escaping (Head.Output.Success, Response.Result.Success) -> Success
    ) -> FlowBuilder.Chain< Head, Api.Flow.Query< Head.Output, Provider, Response, Success > > {
        return .init(head: self.head, tail: self.head.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation, map: map))
    }
}

public extension FlowBuilder.Chain {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> FlowBuilder.Chain< Head, Api.Flow.Query< Tail.Output, Provider, Response, Response.Success > > {
        return .init(head: self.head, tail: self.tail.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation))
    }
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse,
        Success
    >(
        provider: Provider,
        dispatch: FlowOperator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        map: @escaping (Tail.Output.Success, Response.Result.Success) -> Success
    ) -> FlowBuilder.Chain< Head, Api.Flow.Query< Tail.Output, Provider, Response, Success > > {
        return .init(head: self.head, tail: self.tail.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation, map: map))
    }
    
}
