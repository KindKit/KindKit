//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol ISyncDataLoader {
    
    associatedtype Result
    associatedtype Error
    
    typealias Success = (_ result: Result) -> Void
    typealias Failure = (_ error: Error) -> Void
    
    func shouldPerform() -> Bool
    
    func perform(success: @escaping Success, failure: @escaping Failure) -> ICancellable
    
    mutating func didPerform(result: Result)
    
    mutating func didPerform(error: Error)
    
}

public extension ISyncDataLoader {
    
    func shouldPerform() -> Bool {
        return true
    }
    
    func didPerform(result: Result) {
    }

    func didPerform(error: Error) {
    }

}

open class SyncDataSource< Loader : ISyncDataLoader > : ISyncDataSource, ICancellable {
    
    public typealias Result = Loader.Result
    public typealias Error = Loader.Error
    
    public var loader: Loader
    public private(set) var result: Result?
    public private(set) var error: Error?
    public var isSyncing: Bool {
        return self._query != nil
    }
    public var isNeedSync: Bool {
        guard let syncAt = self.syncAt else { return true }
        return self.isNeedSync(syncAt: syncAt)
    }
    public private(set) var syncAt: Date?
    
    private var _query: ICancellable?
    
    public init(
        loader: Loader
    ) {
        self.loader = loader
    }
    
    deinit {
        self._query?.cancel()
        self._query = nil
    }
    
    open func isNeedSync(syncAt: Date) -> Bool {
        return false
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
        guard self.loader.shouldPerform() == true else { return }
        self.willSync()
        self._query = self.loader.perform(
            success: { [weak self] result in self?._didSync(result: result) },
            failure: { [weak self] error in self?._didSync(error: error) }
        )
    }
    
    public func cancel() {
        self._query?.cancel()
        self._query = nil
        self.didCancel()
    }
    
    open func willSync() {
    }

    open func didSync(result: Result) {
    }

    open func didSync(error: Error) {
    }
    
    open func didCancel() {
    }

}

private extension SyncDataSource {

    func _didSync(result: Result) {
        self._query = nil
        self.result = result
        self.error = nil
        self.syncAt = Date()
        self.loader.didPerform(result: result)
        self.didSync(result: result)
    }

    func _didSync(error: Error) {
        self._query = nil
        self.error = error
        self.loader.didPerform(error: error)
        self.didSync(error: error)
    }
    
}
