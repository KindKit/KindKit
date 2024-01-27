//
//  KindKit
//

import Foundation
import KindEvent
import KindNetwork

public final class ApiSync< Response : KindNetwork.Response > : Sync {
    
    public typealias Success = Response.Success
    public typealias Failure = Response.Failure
    public typealias Result = Swift.Result< Success, Failure >
    
    public let behaviour: SyncBehaviour
    public var isSyncing: Bool {
        return self._task != nil
    }
    public var isNeedSync: Bool {
        return self.behaviour.isNeedSync(self.syncAt)
    }
    public private(set) var syncAt: Date?
    public private(set) var result: Result?
    public let onFinish = Signal< Void, Result >()
    
    private let _provider: KindNetwork.Provider
    private let _request: () throws -> KindNetwork.Request
    private let _response: () -> Response
    private var _task: CancelTrait?
    
    public init(
        behaviour: SyncBehaviour,
        provider: KindNetwork.Provider,
        request: @escaping () throws -> KindNetwork.Request,
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
            completed: { [weak self] in
                guard let self = self else { return }
                self._task = nil
                if $0.isSuccess == true {
                    self.syncAt = Date()
                }
                self.result = $0
                self.onFinish.emit($0)
            }
        )
    }
    
    public func cancel() {
        self._task?.cancel()
        self._task = nil
    }
    
}

extension ApiSync : @unchecked Sendable {
}
