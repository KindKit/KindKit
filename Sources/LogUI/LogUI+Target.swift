//
//  KindKit
//

import Foundation

protocol ILogUITargetObserver : AnyObject {
    
    func append(_ target: LogUI.Target, item: LogUI.Target.Item)
    func remove(_ target: LogUI.Target, item: LogUI.Target.Item)

}

public extension LogUI {

    final class Target {
        
        public let limit: Int
        var items: [Item] {
            return self._queue.sync(flags: .barrier, execute: {
                return self._items
            })
        }

        private var _items: [Item]
        private let _queue: DispatchQueue
        private let _observer: Observer< ILogUITargetObserver >
        
        public init(
            limit: Int = 512
        ) {
            self.limit = limit
            self._items = []
            self._queue = .init(label: "KindKit.LogUI.Target")
            self._observer = Observer()
        }

    }

}

extension LogUI.Target {
    
    func add(observer: ILogUITargetObserver, priority: ObserverPriority) {
        self._observer.add(observer, priority: priority)
    }
    
    func remove(observer: ILogUITargetObserver) {
        self._observer.remove(observer)
    }
    
}

extension LogUI.Target : ILogTarget {
    
    public var files: [URL] {
        return []
    }
    
    public func log(level: Log.Level, category: String, message: String) {
        let item = Item(date: Date(), level: level, category: category, message: message)
        self._queue.async(execute: { [weak self] in
            guard let self = self else { return }
            self._log(item: item)
        })
        
    }
    
}

private extension LogUI.Target {
    
    func _log(item: Item) {
        self._items.append(item)
        let removeItem: Item?
        if self._items.count > self.limit {
            removeItem = self._items.removeFirst()
        } else {
            removeItem = nil
        }
        DispatchQueue.main.async(execute: {[weak self] in
            guard let self = self else { return }
            self._didLog(append: item, remove: removeItem)
        })
    }
    
    func _didLog(append: Item, remove: Item?) {
        self._observer.notify({ $0.append(self, item: append) })
        if let remove = remove {
            self._observer.notify({ $0.remove(self, item: remove) })
        }
    }
    
}
