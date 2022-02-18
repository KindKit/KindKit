//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol ISimpleEmptyActionDataLoader {
    
    associatedtype Error
    
    typealias Success = () -> Void
    typealias Failure = (_ error: Error) -> Void
    
    func shouldPerform() -> Bool
    
    func perform(success: @escaping Success, failure: @escaping Failure) -> ICancellable
    
    mutating func didPerform()
    
    mutating func didPerform(error: Error)
    
}

public extension ISimpleEmptyActionDataLoader {
    
    func shouldPerform() -> Bool {
        return true
    }
    
    func didPerform() {
    }

    func didPerform(error: Error) {
    }

}

open class SimpleEmptyActionDataSource< Loader : ISimpleEmptyActionDataLoader > : ISimpleEmptyActionDataSource, ICancellable {
    
    public typealias Error = Loader.Error
    
    public var loader: Loader
    public private(set) var error: Error?
    public var isPerforming: Bool {
        return self._query != nil
    }
    
    private var _query: ICancellable?
    
    public init(loader: Loader) {
        self.loader = loader
    }
    
    deinit {
        self._query?.cancel()
        self._query = nil
    }

    public func perform() {
        guard self.isPerforming == false else { return }
        guard self.loader.shouldPerform() == true else { return }
        self.willPerform()
        self._query = self.loader.perform(
            success: { [weak self] in self?._didPerform() },
            failure: { [weak self] error in self?._didPerform(error: error) }
        )
    }
    
    public func cancel() {
        self._query?.cancel()
        self._query = nil
    }
    
    open func willPerform() {
    }

    open func didPerform() {
    }

    open func didPerform(error: Error) {
    }

}

private extension SimpleEmptyActionDataSource {

    func _didPerform() {
        self._query = nil
        self.error = nil
        self.loader.didPerform()
        self.didPerform()
    }

    func _didPerform(error: Error) {
        self._query = nil
        self.error = error
        self.loader.didPerform(error: error)
        self.didPerform(error: error)
    }
    
}
