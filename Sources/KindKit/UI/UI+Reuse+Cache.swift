//
//  KindKit
//

import Foundation

public extension UI.Reuse {

    final class Cache {
        
        private var _items: [String : [Any]]
        
        fileprivate init() {
            self._items = [:]
        }
        
        public func set< Reusable : IUIReusable >(_ reusable: Reusable.Type, name: String?, content: Reusable.Content) {
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
        
        public func get< Reusable : IUIReusable >(_ reusable: Reusable.Type, name: String?, owner: Reusable.Owner) -> Reusable.Content {
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

}

public extension UI.Reuse.Cache {
    
    static let shared = UI.Reuse.Cache()
    
}
