//
//  KindKit
//

public protocol IViewSupportItems : AnyObject {
    
    associatedtype Item
    
    var items: [Item] { set get }
    
    func index(`where` block: (Item) -> Bool) -> Int?
    
    @discardableResult
    func insert< Sequence : Collection >(_ items: Sequence, at index: Int) -> Self where Sequence.Element == Item
    
    @discardableResult
    func delete(at index: Int) -> Self
    
    @discardableResult
    func delete(_ range: Range< Int >) -> Self
    
}

public extension IViewSupportItems {
    
    @inlinable
    @discardableResult
    func items(_ value: [Item]) -> Self {
        self.items = value
        return self
    }

    @inlinable
    @discardableResult
    func items(on: () -> [Item]) -> Self {
        self.items = on()
        return self
    }

    @inlinable
    @discardableResult
    func items(on: (Self) -> [Item]) -> Self {
        self.items = on(self)
        return self
    }
    
}

public extension IViewSupportItems {
    
    @inlinable
    func indices(`where` block: (Item) -> Bool) -> [Int] {
        var indices: [Int] = []
        for index in 0 ..< self.items.count {
            let item = self.items[index]
            if block(item) == true {
                indices.append(index)
            }
        }
        return indices
    }
    
    @inlinable
    @discardableResult
    func insert(_ item: Item, at index: Int) -> Self {
        return self.insert([ item ], at: index)
    }
    
    @inlinable
    @discardableResult
    func delete(at indices: [Int]) -> Self {
        for index in indices.reversed() {
            self.delete(at: index)
        }
        return self
    }
    
}

public extension IViewSupportItems where Item : Comparable {
    
    @inlinable
    func contains(_ item: Item) -> Bool {
        return self.index(of: item) != nil
    }
    
    @inlinable
    func index(of item: Item) -> Int? {
        return self.index(where: { $0 == item })
    }
    
    @inlinable
    func indices(of items: [Item]) -> [Int] {
        return self.indices(where: { item in
            return items.contains(item)
        })
    }
    
    @inlinable
    @discardableResult
    func delete(_ item: Item) -> Self {
        guard let index = self.index(of: item) else {
            return self
        }
        return self.delete(at: index)
    }
    
    @inlinable
    @discardableResult
    func delete(_ items: [Item]) -> Self {
        return self.delete(at: self.indices(of: items))
    }
    
}

public extension IViewSupportItems where Item : AnyObject {
    
    @inlinable
    func contains(_ item: Item) -> Bool {
        return self.index(of: item) != nil
    }
    
    @inlinable
    func index(of item: Item) -> Int? {
        return self.index(where: { $0 === item })
    }
    
    @inlinable
    func indices(of items: [Item]) -> [Int] {
        return self.indices(where: { item in
            items.contains(where: { $0 === item })
        })
    }
    
    @inlinable
    @discardableResult
    func delete(_ item: Item) -> Self {
        guard let index = self.index(of: item) else { 
            return self
        }
        return self.delete(at: index)
    }
    
    @inlinable
    @discardableResult
    func delete(_ items: [Item]) -> Self {
        return self.delete(at: self.indices(of: items))
    }
    
}

public extension IViewSupportItems where Self : CompositorTrait, Body : IViewSupportItems {
    
    @inlinable
    var items: [Body.Item] {
        set { self.body.items = newValue }
        get { self.body.items }
    }
    
    @inlinable
    func index(`where` block: (Body.Item) -> Bool) -> Int? {
        return self.body.index(where: block)
    }
    
    @inlinable
    @discardableResult
    func insert< Sequence : Collection >(_ items: Sequence, at index: Int) -> Self where Sequence.Element == Body.Item {
        self.body.insert(items, at: index)
        return self
    }
    
    @inlinable
    @discardableResult
    func delete(at index: Int) -> Self {
        self.body.delete(at: index)
        return self
    }
    
    @inlinable
    @discardableResult
    func delete(_ range: Range< Int >) -> Self {
        self.body.delete(range)
        return self
    }
    
}
