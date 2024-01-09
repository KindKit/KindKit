//
//  KindKit
//

import Foundation

public extension DataSource.Sync {
    
    final class Api< Response : IApiResponse > : ISyncDataSource {
        
        public typealias Success = Response.Success
        public typealias Failure = Response.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public var isSyncing: Bool {
            return self._task != nil
        }
        public var isNeedSync: Bool {
            return self.behaviour.isNeedSync(self.syncAt)
        }
        public private(set) var syncAt: Date?
        public private(set) var result: Result?
        public let onFinish = Signal.Args< Void, Result >()
        public let behaviour: Behaviour
        
        private let _provider: KindKit.Api.Provider
        private let _request: () throws -> KindKit.Api.Request
        private let _response: () -> Response
        private var _task: ICancellable?
        
        public init(
            behaviour: Behaviour,
            provider: KindKit.Api.Provider,
            request: @escaping () throws -> KindKit.Api.Request,
            response: @escaping () -> Response
        ) {
            self.behaviour = behaviour
            self._provider = provider
            self._request = request
            self._response = response
        }
        
        deinit {
            self.cancel()
        }
        
        public func setNeedSync(reset: Bool) {
            if reset == true {
                self.result = nil
            }
            self.syncAt = nil
        }
        
        public func sync() {
            guard self.isSyncing == false else { return }
            self._task = self._provider.send(
                request: try self._request(),
                response: self._response(),
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

private extension DataSource.Sync.Api {

    func _completed(_ result: Result) {
        switch result {
        case .success:
            self.result = result
            self.syncAt = Date()
        case .failure:
            self.result = result
        }
        self._task = nil
        self.onFinish.emit(result)
    }
    
}
