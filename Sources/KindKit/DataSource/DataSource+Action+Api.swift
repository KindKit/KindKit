//
//  KindKit
//

import Foundation

public extension DataSource.Action {
    
    final class Api<
        Params,
        Response : IApiResponse
    > : IActionDataSource {
        
        public typealias Success = Response.Success
        public typealias Failure = Response.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public var isPerforming: Bool {
            return self._task != nil
        }
        public private(set) var result: Result?
        public let onFinish: Signal.Args< Void, Result > = .init()
        
        private let _provider: KindKit.Api.Provider
        private let _request: (Params) throws -> KindKit.Api.Request
        private let _response: (Params) -> Response
        private var _task: ICancellable?
        
        public init(
            provider: KindKit.Api.Provider,
            request: @escaping (Params) throws -> KindKit.Api.Request,
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
                completed: { [weak self] in self?._completed($0) }
            )
        }
        
        public func cancel() {
            self._task?.cancel()
            self._task = nil
        }

    }
    
}

private extension DataSource.Action.Api {
    
    func _completed(_ result: Result) {
        self.result = result
        self._task = nil
        self.onFinish.emit(result)
    }
    
}
