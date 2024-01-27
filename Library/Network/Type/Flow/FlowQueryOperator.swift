//
//  KindKit
//

import Dispatch
import KindFlow
import KindLog
import KindMeasure

public final class FlowQueryOperator< Input : ResultTrait, Response : KindNetwork.Response > : Operator where Input.Success : Sendable {

    public typealias Input = Input
    public typealias Output = Response.Result
    
    private let _provider: @Sendable (Input.Success) -> Provider
    private let _queue: DispatchQueue
    private let _request: @Sendable (Input.Success) throws -> Request
    private let _response: @Sendable (Input.Success) -> Response
    private var _task: CancelTrait? {
        willSet { self._task?.cancel() }
    }
    private var _next: KindFlow.Pipe!
    
    init(
        _ provider: @escaping @Sendable (Input.Success) -> Provider,
        _ queue: DispatchQueue,
        _ request: @escaping @Sendable (Input.Success) throws -> Request,
        _ response: @escaping @Sendable (Input.Success) -> Response
    ) {
        self._provider = provider
        self._queue = queue
        self._request = request
        self._response = response
    }
    
    deinit {
        if let task = self._task {
            task.cancel()
            self._task = nil
        }
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            if let task = self._task {
                task.cancel()
                self._task = nil
            }
            switch result {
            case .success(let value):
                let provider = self._provider(value)
                self._task = provider.send(
                    request: try self._request(value),
                    response: self._response(value),
                    queue: self._queue,
                    completed: { [weak self] in
                        guard let self = self else { return }
                        switch $0 {
                        case .success(let value): self._next.send(value: value)
                        case .failure(let error): self._next.send(error: error)
                        }
                        self._next.completed()
                    }
                )
            case .failure(let error):
                self._next.send(error: error)
                self._next.completed()
            }
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                if let task = self._task {
                    task.cancel()
                    self._task = nil
                }
                self._next.cancel()
            }
        }
    }
    
}

extension FlowQueryOperator : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func query<
        Response : KindNetwork.Response
    >(
        provider: @escaping @Sendable (Tail.Output.Success) -> Provider,
        queue: DispatchQueue,
        request: @escaping @Sendable (Tail.Output.Success) throws -> Request,
        response: @escaping @Sendable (Tail.Output.Success) -> Response
    ) -> BuilderChain<
        Head,
        FlowQueryOperator< Tail.Output, Response >
    > {
        return self.append(.init(provider, queue, request, response))
    }
    
}
