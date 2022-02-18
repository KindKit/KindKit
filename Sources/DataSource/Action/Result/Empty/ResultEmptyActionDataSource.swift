//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IResultEmptyActionDataLoader {
    
    associatedtype Result
    associatedtype Error
    
    typealias Success = (_ result: Result) -> Void
    typealias Failure = (_ error: Error) -> Void
    
    func shouldPerform() -> Bool
    
    func perform(success: @escaping Success, failure: @escaping Failure) -> ICancellable
    
    mutating func didPerform(result: Result)
    
    mutating func didPerform(error: Error)
    
}

public extension IResultEmptyActionDataLoader {
    
    func shouldPerform() -> Bool {
        return true
    }
    
    func didPerform(result: Result) {
    }

    func didPerform(error: Error) {
    }

}

open class ResultEmptyActionDataSource< Loader : IResultEmptyActionDataLoader > : IResultEmptyActionDataSource, ICancellable {
    
    public typealias Result = Loader.Result
    public typealias Error = Loader.Error
    
    public var loader: Loader
    public private(set) var result: Result?
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
            success: { [weak self] result in self?._didPerform(result: result) },
            failure: { [weak self] error in self?._didPerform(error: error) }
        )
    }
    
    public func cancel() {
        self._query?.cancel()
        self._query = nil
    }
    
    open func willPerform() {
    }

    open func didPerform(result: Result) {
    }

    open func didPerform(error: Error) {
    }

}

private extension ResultEmptyActionDataSource {

    func _didPerform(result: Result) {
        self._query = nil
        self.result = result
        self.error = nil
        self.loader.didPerform(result: result)
        self.didPerform(result: result)
    }

    func _didPerform(error: Error) {
        self._query = nil
        self.error = error
        self.loader.didPerform(error: error)
        self.didPerform(error: error)
    }
    
}
