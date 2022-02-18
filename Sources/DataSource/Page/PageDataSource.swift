//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol IPageDataLoader {
    
    associatedtype Result : RangeReplaceableCollection
    associatedtype Error
    
    typealias Success = (_ result: Result, _ canMore: Bool) -> Void
    typealias Failure = (_ error: Error) -> Void
    
    func shouldPerform() -> Bool
    
    func perform(reload: Bool, success: @escaping Success, failure: @escaping Failure) -> ICancellable
    
    mutating func didPerform(isFirst: Bool, result: Result, canMore: Bool)
    
    mutating func didPerform(error: Error)
    
}

public extension IPageDataLoader {
    
    func shouldPerform() -> Bool {
        return true
    }
    
    func didPerform(isFirst: Bool, result: Result, canMore: Bool) {
    }

    func didPerform(error: Error) {
    }

}

open class PageDataSource< Loader : IPageDataLoader > : IPageDataSource, ICancellable {
    
    public typealias Result = Loader.Result
    public typealias Error = Loader.Error
    
    public var loader: Loader
    public private(set) var result: Result?
    public private(set) var error: Error?
    public var isLoading: Bool {
        return self._query != nil
    }
    public private(set) var canMore: Bool
    
    private var _query: ICancellable?
    
    public init(loader: Loader) {
        self.canMore = true
        self.loader = loader
    }
    
    deinit {
        self._query?.cancel()
        self._query = nil
    }

    public func load(reload: Bool) {
        guard self.isLoading == false else { return }
        guard self.loader.shouldPerform() == true else { return }
        let isFirst = reload == true || self.result == nil
        self.willLoad()
        self._query = self.loader.perform(
            reload: isFirst,
            success: { [weak self] result, canMore in self?._didLoad(isFirst: isFirst, result: result, canMore: canMore) },
            failure: { [weak self] error in self?._didLoad(error: error) }
        )
    }
    
    public func cancel() {
        self._query?.cancel()
        self._query = nil
    }
    
    open func willLoad() {
    }

    open func didLoad(isFirst: Bool, result: Result, canMore: Bool) {
    }

    open func didLoad(error: Error) {
    }

}

private extension PageDataSource {

    func _didLoad(isFirst: Bool, result: Result, canMore: Bool) {
        self._query = nil
        if isFirst == true || self.result == nil {
            self.result = result
        } else {
            self.result?.append(contentsOf: result)
        }
        self.error = nil
        self.canMore = canMore
        self.loader.didPerform(isFirst: isFirst, result: result, canMore: canMore)
        self.didLoad(isFirst: isFirst, result: result, canMore: canMore)
    }

    func _didLoad(error: Error) {
        self._query = nil
        self.error = error
        self.loader.didPerform(error: error)
        self.didLoad(error: error)
    }
    
}
