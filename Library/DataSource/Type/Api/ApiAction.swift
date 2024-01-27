//
//  KindKit
//

import KindEvent
import KindNetwork

public final class ApiAction<
    Params : Sendable,
    Response : KindNetwork.Response
> : Action {
    
    public typealias Success = Response.Success
    public typealias Failure = Response.Failure
    public typealias Result = Swift.Result< Success, Failure >
    
    public var isPerforming: Bool {
        return self._task != nil
    }
    
    public private(set) var result: Result?
    
    public let onFinish = Signal< Void, Result >()
    
    private let _provider: KindNetwork.Provider
    private let _request: (Params) throws -> KindNetwork.Request
    private let _response: (Params) -> Response
    private var _task: CancelTrait?
    
    public init(
        provider: KindNetwork.Provider,
        request: @escaping (Params) throws -> KindNetwork.Request,
        response: @escaping (Params) -> Response
    ) {
        self._provider = provider
        self._request = request
        self._response = response
    }
    
    deinit {
        self.cancel()
    }
    
    public func perform(params: Params) {
        guard self.isPerforming == false else { return }
        self._task = self._provider.send(
            request: try self._request(params),
            response: self._response(params),
            queue: .main,
            completed: { [weak self] in
                guard let self = self else { return }
                self.result = $0
                self._task = nil
                self.onFinish.emit($0)
            }
        )
    }
    
    public func cancel() {
        self._task?.cancel()
        self._task = nil
    }
    
}

extension ApiAction : @unchecked Sendable {
}
