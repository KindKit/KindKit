//
//  KindKit
//

public final class ReuseCache {
    
    private var _items: [String : [Any]]
    
    fileprivate init() {
        self._items = [:]
    }
    
    public func set< Reusable : IReusable >(_ reusable: Reusable.Type, owner: Reusable.Owner, content: Reusable.Content) {
        let name = reusable.name(owner: owner)
        if let items = self._items[name] {
            self._items[name] = items + [ content ]
        } else {
            self._items[name] = [ content ]
        }
        reusable.cleanup(owner: owner, content: content)
    }
    
    public func get< Reusable : IReusable >(_ reusable: Reusable.Type, owner: Reusable.Owner) -> Reusable.Content {
        let name = reusable.name(owner: owner)
        let item: Reusable.Content
        if let items = self._items[name] {
            if let lastItem = items.last as? Reusable.Content {
                self._items[name] = items.dropLast()
                item = lastItem
            } else {
                item = reusable.create(owner: owner)
            }
        } else {
            item = reusable.create(owner: owner)
        }
        reusable.configure(owner: owner, content: item)
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

public extension ReuseCache {
    
    static let `default` = ReuseCache()
    
}
