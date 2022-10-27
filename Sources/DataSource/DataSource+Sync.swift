//
//  KindKit
//

import Foundation

public extension DataSource {
    
    final class Sync< Provider : IApiProvider, Response : IApiResponse > : ISyncDataSource, ICancellable {
        
        public typealias Success = Response.Success
        public typealias Failure = Response.Failure
        public typealias Result = Swift.Result< Success, Failure >
        
        public let behaviour: Behaviour
        public private(set) var result: Result?
        public var isSyncing: Bool {
            return self._task != nil
        }
        public var isNeedSync: Bool {
            return self.behaviour.isNeedSync(syncAt)
        }
        public private(set) var syncAt: Date?
        
        private let _provider: Provider
        private let _request: () throws -> Api.Request?
        private let _response: () -> Response
        private let _completed: (Result) -> Void
        private var _task: ICancellable?
        
        public init(
            behaviour: Behaviour,
            provider: Provider,
            request: @escaping () throws -> Api.Request?,
            response: @escaping () -> Response,
            completed: @escaping (Result) -> Void
        ) {
            self.behaviour = behaviour
            self._provider = provider
            self._request = request
            self._response = response
            self._completed = completed
        }
        
        deinit {
            self._task?.cancel()
            self._task = nil
        }
        
        public func setNeedSync(reset: Bool) {
            if reset == true {
                self.result = nil
            }
            self.syncAt = nil
        }
        
        public func syncIfNeeded() {
            guard self.isSyncing == false else { return }
            guard self.isNeedSync == true else { return }
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

private extension DataSource.Sync {

    func _completed(_ result: Result) {
        switch result {
        case .success:
            self.result = result
            self.syncAt = Date()
        case .failure:
            self.result = result
        }
        self._completed(result)
        self._task = nil
    }
    
}
