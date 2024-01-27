//
//  KindKit
//

import KindUI

public protocol IViewSupportItems : AnyObject {
    
    associatedtype ItemType
    
    var items: [ItemType] { set get }
    
    func index(`where` block: (ItemType) -> Bool) -> Int?
    
    @discardableResult
    func insert< SequenceType : Collection >(_ items: SequenceType, at index: Int) -> Self where SequenceType.Element == ItemType
    
    @discardableResult
    func delete(at index: Int) -> Self
    
    @discardableResult
    func delete(_ range: Range< Int >) -> Self
    
}

public extension IViewSupportItems {
    
    @inlinable
    @discardableResult
    func items(_ value: [ItemType]) -> Self {
        self.items = value
        return self
    }

    @inlinable
    @discardableResult
    func items(_ value: () -> [ItemType]) -> Self {
        self.items = value()
        return self
    }

    @inlinable
    @discardableResult
    func items(_ value: (Self) -> [ItemType]) -> Self {
        self.items = value(self)
        return self
    }
    
}

public extension IViewSupportItems {
    
    @inlinable
    func indices(`where` block: (ItemType) -> Bool) -> [Int] {
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
    func insert(_ item: ItemType, at index: Int) -> Self {
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

public extension IViewSupportItems where ItemType : Comparable {
    
    @inlinable
    func contains(_ item: ItemType) -> Bool {
        return self.index(of: item) != nil
    }
    
    @inlinable
    func index(of item: ItemType) -> Int? {
        return self.index(where: { $0 == item })
    }
    
    @inlinable
    func indices(of items: [ItemType]) -> [Int] {
        return self.indices(where: { item in
            return items.contains(item)
        })
    }
    
    @inlinable
    @discardableResult
    func delete(_ item: ItemType) -> Self {
        guard let index = self.index(of: item) else {
            return self
        }
        return self.delete(at: index)
    }
    
    @inlinable
    @discardableResult
    func delete(_ items: [ItemType]) -> Self {
        return self.delete(at: self.indices(of: items))
    }
    
}

public extension IViewSupportItems where ItemType : AnyObject {
    
    @inlinable
    func contains(_ item: ItemType) -> Bool {
        return self.index(of: item) != nil
    }
    
    @inlinable
    func index(of item: ItemType) -> Int? {
        return self.index(where: { $0 === item })
    }
    
    @inlinable
    func indices(of items: [ItemType]) -> [Int] {
        return self.indices(where: { item in
            items.contains(where: { $0 === item })
        })
    }
    
    @inlinable
    @discardableResult
    func delete(_ item: ItemType) -> Self {
        guard let index = self.index(of: item) else { 
            return self
        }
        return self.delete(at: index)
    }
    
    @inlinable
    @discardableResult
    func delete(_ items: [ItemType]) -> Self {
        return self.delete(at: self.indices(of: items))
    }
    
}

public extension IViewSupportItems where Self : IComposite, BodyType : IViewSupportItems {
    
    @inlinable
    var items: [BodyType.ItemType] {
        set { self.body.items = newValue }
        get { self.body.items }
    }
    
    @inlinable
    func index(`where` block: (BodyType.ItemType) -> Bool) -> Int? {
        return self.body.index(where: block)
    }
    
    @inlinable
    @discardableResult
    func insert< SequenceType : Collection >(_ items: SequenceType, at index: Int) -> Self where SequenceType.Element == BodyType.ItemType {
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
