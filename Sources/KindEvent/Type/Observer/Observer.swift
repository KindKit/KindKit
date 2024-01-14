//
//  KindKit
//

public final class Observer< Target > {

    private var _items: [Item]

    public init() {
        self._items = []
    }

}

public extension Observer {
    
    func add(_ observer: Target, priority: UInt) {
        if let index = self._items.firstIndex(where: { $0.contains(observer: observer) }) {
            self._items[index].priority = priority
        } else {
            self._items.append(Item(priority: priority, observer: observer))
        }
        self._items.sort(by: { return $0.priority < $1.priority })
    }
    
    @inlinable
    func add< Priority : RawRepresentable >(_ observer: Target, priority: Priority) where Priority.RawValue == UInt {
        self.add(observer, priority: priority.rawValue)
    }
    
    func remove(_ observer: Target) {
        if let index = self._items.firstIndex(where: { $0.contains(observer: observer) }) {
            self._items.remove(at: index)
        }
    }

    func emit(_ closure: (_ observer: Target) -> Void) {
        self._emit(
            items: self._items,
            closure: closure
        )
    }
    
    func emit(priorities: [UInt], _ closure: (_ observer: Target) -> Void) {
        self._emit(
            items: self._items.filter({ priorities.contains($0.priority) }),
            closure: closure
        )
    }
    
    @inlinable
    func emit< Priority : RawRepresentable >(priorities: [Priority], _ closure: (_ observer: Target) -> Void) where Priority.RawValue == UInt {
        self.emit(priorities: priorities.map({ $0.rawValue }), closure)
    }

    func emit(reverse closure: (_ observer: Target) -> Void) {
        self._emit(
            items: self._items.reversed(),
            closure: closure
        )
    }
    
    func emit(priorities: [UInt], reverse closure: (_ observer: Target) -> Void) {
        self._emit(
            items: self._items.filter({ priorities.contains($0.priority) }).reversed(),
            closure: closure
        )
    }
    
    @inlinable
    func emit< Priority : RawRepresentable >(priorities: [Priority], reverse closure: (_ observer: Target) -> Void) where Priority.RawValue == UInt {
        self.emit(priorities: priorities.map({ $0.rawValue }), reverse: closure)
    }
    
}

private extension Observer {
    
    func _emit(items: [Item], closure: (_ observer: Target) -> Void) {
        var needRemove: [Item] = []
        for item in items {
            if let observer = item.get() {
                closure(observer)
            } else {
                needRemove.append(item)
            }
        }
        if needRemove.isEmpty == false {
            self._items.removeAll(where: { item in
                needRemove.contains(where: { item === $0 })
            })
        }
    }
    
}
