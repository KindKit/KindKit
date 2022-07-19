//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IReusable {
    
    associatedtype Owner : AnyObject
    associatedtype Content
    
    static var reuseIdentificator: String { get }
    
    static func createReuse(owner: Owner) -> Content
    static func configureReuse(owner: Owner, content: Content)
    static func cleanupReuse(content: Content)
    
}

public final class ReuseCache {
    
    public static let shared: ReuseCache = ReuseCache()
    
    private var _items: [String : [Any]]
    
    fileprivate init() {
        self._items = [:]
    }
    
    public func set< Reusable : IReusable >(_ reusable: Reusable.Type, name: String?, content: Reusable.Content) {
        let identificator: String
        if let name = name {
            identificator = "\(reusable.reuseIdentificator)::\(name)"
        } else {
            identificator = reusable.reuseIdentificator
        }
        if let items = self._items[identificator] {
            self._items[identificator] = items + [ content ]
        } else {
            self._items[identificator] = [ content ]
        }
        reusable.cleanupReuse(content: content)
    }
    
    public func get< Reusable : IReusable >(_ reusable: Reusable.Type, name: String?, owner: Reusable.Owner) -> Reusable.Content {
        let identificator: String
        if let name = name {
            identificator = "\(reusable.reuseIdentificator)::\(name)"
        } else {
            identificator = reusable.reuseIdentificator
        }
        let item: Reusable.Content
        if let items = self._items[identificator] {
            if let lastItem = items.last as? Reusable.Content {
                self._items[identificator] = items.dropLast()
                item = lastItem
            } else {
                item = reusable.createReuse(owner: owner)
            }
        } else {
            item = reusable.createReuse(owner: owner)
        }
        reusable.configureReuse(owner: owner, content: item)
        return item
    }
    
    public func reset(count: UInt? = nil) {
        if let count = count {
            for item in self._items {
                guard item.value.count > count else { continue }
                self._items[item.key] = Array(item.value.prefix(Int(count)))
            }
        } else {
            self._items = [:]
        }
    }
    
}
