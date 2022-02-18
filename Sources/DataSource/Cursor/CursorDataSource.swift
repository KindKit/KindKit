//
//  KindKitData
//

import Foundation
import KindKitCore

public protocol ICursorDataLoader {
    
    associatedtype Result : RangeReplaceableCollection
    associatedtype Cursor
    associatedtype Error
    
    typealias Success = (_ result: Result, _ cursor: Cursor, _ canMore: Bool) -> Void
    typealias Failure = (_ error: Error) -> Void
    
    func shouldPerform() -> Bool
    
    func perform(cursor: Cursor?, success: @escaping Success, failure: @escaping Failure) -> ICancellable
    
    mutating func didPerform(isFirst: Bool, result: Result, cursor: Cursor, canMore: Bool)
    
    mutating func didPerform(error: Error)
    
}

public extension ICursorDataLoader {
    
    func shouldPerform() -> Bool {
        return true
    }
    
    func didPerform(isFirst: Bool, result: Result, cursor: Cursor, canMore: Bool) {
    }

    func didPerform(error: Error) {
    }

}

open class CursorDataSource< Loader : ICursorDataLoader > : ICursorDataSource, ICancellable {
    
    public typealias Result = Loader.Result
    public typealias Cursor = Loader.Cursor
    public typealias Error = Loader.Error
    
    public var loader: Loader
    public private(set) var result: Result?
    public private(set) var cursor: Cursor?
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
            cursor: isFirst == true ? nil : self.cursor,
            success: { [weak self] result, cursor, canMore in self?._didLoad(isFirst: isFirst, result: result, cursor: cursor, canMore: canMore) },
            failure: { [weak self] error in self?._didLoad(error: error) }
        )
    }
    
    public func cancel() {
        self._query?.cancel()
        self._query = nil
    }
    
    open func willLoad() {
    }

    open func didLoad(isFirst: Bool, result: Result, cursor: Cursor, canMore: Bool) {
    }

    open func didLoad(error: Error) {
    }

}

private extension CursorDataSource {

    func _didLoad(isFirst: Bool, result: Result, cursor: Cursor, canMore: Bool) {
        self._query = nil
        if isFirst == true || self.result == nil {
            self.result = result
        } else {
            self.result?.append(contentsOf: result)
        }
        self.cursor = cursor
        self.error = nil
        self.canMore = canMore
        self.loader.didPerform(isFirst: isFirst, result: result, cursor: cursor, canMore: canMore)
        self.didLoad(isFirst: isFirst, result: result, cursor: cursor, canMore: canMore)
    }

    func _didLoad(error: Error) {
        self._query = nil
        self.error = error
        self.loader.didPerform(error: error)
        self.didLoad(error: error)
    }
    
}
