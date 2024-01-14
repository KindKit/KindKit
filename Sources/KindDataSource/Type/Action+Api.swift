//
//  KindKit
//

import KindEvent
import KindNetwork

public extension Action {
    
    final class Api< ParamsType, ResponseType : KindNetwork.IResponse > : IAction {
        
        public typealias Success = ResponseType.Success
        public typealias Failure = ResponseType.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public var isPerforming: Bool {
            return self._task != nil
        }
        public private(set) var result: Result?
        public let onFinish = Signal< Void, Result >()
        
        private let _provider: KindNetwork.Provider
        private let _request: (Params) throws -> KindNetwork.Request
        private let _response: (Params) -> ResponseType
        private var _task: ICancellable?
        
        public init(
            provider: KindNetwork.Provider,
            request: @escaping (Params) throws -> KindNetwork.Request,
            response: @escaping (Params) -> ResponseType
        ) {
            self._provider = provider
            self._request = request
            self._response = response
        }
        
        deinit {
            self.cancel()
        }

        public func perform(params: ParamsType) {
            guard self.isPerforming == false else { return }
            self._task = self._provider.send(
                request: try self._request(params),
                response: self._response(params),
                queue: .main,
                completed: { [weak self] in self?._completed($0) }
            )
        }
        
        public func cancel() {
            self._task?.cancel()
            self._task = nil
        }

    }
    
}

private extension Action.Api {
    
    func _completed(_ result: Result) {
        self.result = result
        self._task = nil
        self.onFinish.emit(result)
    }
    
}
