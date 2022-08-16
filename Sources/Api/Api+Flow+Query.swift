//
//  KindKitApi
//

import Foundation
import KindKitCore
import KindKitFlow

public extension Api.Flow {
    
    final class Query< Input : IFlowResult, Provider : IApiProvider, Response : IApiResponse, Success, Failure : Swift.Error > : IFlowOperator {
        
        public typealias Input = Input
        public typealias Output = Result< Success, Failure >
        
        private let _provider: Provider
        private let _queue: DispatchQueue
        private let _request: (Input.Success) throws -> Api.Request?
        private let _response: (Input.Success) -> Response
        private let _validation: (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation
        private let _transform: (Input.Success, Response.Result) -> Output
        private var _task: ICancellable?
        private var _next: IFlowPipe!
        
        init(
            _ provider: Provider,
            _ dispatch: KindKitFlow.Operator.DispatchMode,
            _ request: @escaping (Input.Success) throws -> Api.Request?,
            _ response: @escaping (Input.Success) -> Response,
            _ validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation,
            _ transform: @escaping (Input.Success, Response.Result) -> Output
        ) {
            self._provider = provider
            self._queue = dispatch.queue
            self._request = request
            self._response = response
            self._validation = validation
            self._transform = transform
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
    
    func _run(_ date: Date, _ input: Input.Success) {
        self._task = self._provider.send(
            request: try self._request(input),
            response: self._response(input),
            queue: self._queue,
            completed: { [unowned self] in self._completed(date, input, $0) }
        )
    }

    func _completed(_ date: Date, _ input: Input.Success, _ output: Result< Response.Success, Response.Failure >) {
        self._task = nil
        switch self._validation(input, output, Date().timeIntervalSince(date)) {
        case .retry(let delay):
            self._task = DispatchWorkItem.async(
                block: { [unowned self] in
                    self._run(date, input)
                },
                queue: self._queue,
                delay: delay
            )
        case .done:
            switch self._transform(input, output) {
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

extension IFlowOperator {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Output.Success) throws -> Api.Request?,
        response: @escaping (Output.Success) -> Response,
        validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Api.Flow.Query< Output, Provider, Response, Response.Success, Response.Failure > {
        let next = Api.Flow.Query< Output, Provider, Response, Response.Success, Response.Failure >(provider, dispatch, request, response, validation, { _, response in response })
        self.subscribe(next: next)
        return next
    }
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse,
        Success,
        Failure : Swift.Error
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Output.Success) throws -> Api.Request?,
        response: @escaping (Output.Success) -> Response,
        validation: @escaping (Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        transform: @escaping (Output.Success, Response.Result) -> Result< Success, Failure >
    ) -> Api.Flow.Query< Output, Provider, Response, Success, Failure > {
        let next = Api.Flow.Query< Output, Provider, Response, Success, Failure >(provider, dispatch, request, response, validation, transform)
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
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Builder.Head< Api.Flow.Query< Input, Provider, Response, Response.Success, Response.Failure > > {
        return .init(head: .init(provider, dispatch, request, response, validation, { _, response in response }))
    }
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Input.Success) throws -> Api.Request?,
        response: @escaping (Input.Success) -> Response,
        validation: @escaping (Input.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        transform: @escaping (Input.Success, Response.Result) -> Result< Success, Failure >
    ) -> Builder.Head< Api.Flow.Query< Input, Provider, Response, Success, Failure > > {
        return .init(head: .init(provider, dispatch, request, response, validation, transform))
    }
    
}

public extension Builder.Head {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Builder.Chain< Head, Api.Flow.Query< Head.Output, Provider, Response, Response.Success, Response.Failure > > {
        return .init(head: self.head, tail: self.head.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation, transform: { _, response in response }))
    }
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Head.Output.Success) throws -> Api.Request?,
        response: @escaping (Head.Output.Success) -> Response,
        validation: @escaping (Head.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        transform: @escaping (Head.Output.Success, Response.Result) -> Result< Success, Failure >
    ) -> Builder.Chain< Head, Api.Flow.Query< Head.Output, Provider, Response, Success, Failure > > {
        return .init(head: self.head, tail: self.head.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation, transform: transform))
    }
}

public extension Builder.Chain {
    
    func apiQuery<
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done }
    ) -> Builder.Chain< Head, Api.Flow.Query< Tail.Output, Provider, Response, Response.Success, Response.Failure > > {
        return .init(head: self.head, tail: self.tail.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation, transform: { _, response in response }))
    }
    
    func apiQuery<
        Success,
        Failure : Swift.Error,
        Provider : IApiProvider,
        Response : IApiResponse
    >(
        provider: Provider,
        dispatch: KindKitFlow.Operator.DispatchMode,
        request: @escaping (Tail.Output.Success) throws -> Api.Request?,
        response: @escaping (Tail.Output.Success) -> Response,
        validation: @escaping (Tail.Output.Success, Response.Result, TimeInterval) -> Api.Flow.Validation = { _, _, _ in .done },
        transform: @escaping (Tail.Output.Success, Response.Result) -> Result< Success, Failure >
    ) -> Builder.Chain< Head, Api.Flow.Query< Tail.Output, Provider, Response, Success, Failure > > {
        return .init(head: self.head, tail: self.tail.apiQuery(provider: provider, dispatch: dispatch, request: request, response: response, validation: validation, transform: transform))
    }
    
}
