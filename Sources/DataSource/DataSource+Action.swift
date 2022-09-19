//
//  KindKit
//

import Foundation

public extension DataSource {
    
    final class Action< Provider : IApiProvider, Response : IApiResponse, Params > : IActionDataSource, ICancellable {
        
        public typealias Success = Response.Success
        public typealias Failure = Response.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public private(set) var result: Result?
        public var isPerforming: Bool {
            return self._task != nil
        }
        
        private let _provider: Provider
        private let _request: (Params) throws -> Api.Request?
        private let _response: (Params) -> Response
        private let _completed: (Result) -> Void
        private var _task: ICancellable?
        
        public init(
            provider: Provider,
            request: @escaping (Params) throws -> Api.Request?,
            response: @escaping (Params) -> Response,
            completed: @escaping (Result) -> Void
        ) {
            self._provider = provider
            self._request = request
            self._response = response
            self._completed = completed
        }
        
        deinit {
            self._task?.cancel()
            self._task = nil
        }

        public func perform(params: Params) {
            guard self.isPerforming == false else { return }
            self._task = self._provider.send(
                request: try self._request(params),
                response: self._response(params),
                queue: .main,
                completed: { [unowned self] in self._completed($0) }
            )
        }
        
        public func cancel() {
            self._task?.cancel()
            self._task = nil
        }

    }
    
}

private extension DataSource.Action {
    
    func _completed(_ result: Result) {
        self.result = result
        self._completed(result)
        self._task = nil
    }
    
}
