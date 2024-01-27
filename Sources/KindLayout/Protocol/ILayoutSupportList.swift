//
//  KindKit
//

import KindMath

public protocol ILayoutSupportList : AnyObject {
    
    var content: [ILayout] { set get }
    
    func contains(_ content: ILayout) -> Bool
    
    func index(_ content: ILayout) -> Int?
    
    func index(`where`: (ILayout) -> Bool) -> Int?
    
    func index< FindType : ILayout >(`as` type: FindType.Type, `where`: (FindType) -> Bool) -> Int?
    
    func indices(_ content: [ILayout]) -> [Int]
    
    func indices< FindType : ILayout >(`as` type: FindType.Type, `where`: (FindType) -> Bool) -> [Int]

    func insert(_ content: ILayout, at index: Int)
    
    func insert(_ content: [ILayout], at index: Int)
    
    func delete(_ index: Int)
    
    func delete(_ content: ILayout)
    
    func delete(_ content: [ILayout])
    
    func delete(_ range: Range< Int >)
    
}

public extension ILayoutSupportList {
    
    @inlinable
    @discardableResult
    func content(@SequenceBuilder builder: () -> [ILayout]) -> Self {
        self.content = builder()
        return self
    }
    
}

public extension ILayoutSupportList where Self : IComposite, BodyType : ILayoutSupportList {
    
    @inlinable
    var content: [ILayout] {
        set { self.body.content = newValue }
        get { self.body.content }
    }
    
    func contains(_ content: ILayout) -> Bool {
        return self.body.contains(content)
    }
    
    func index(_ content: ILayout) -> Int? {
        return self.body.index(content)
    }
    
    func index(`where`: (ILayout) -> Bool) -> Int? {
        return self.body.index(where: `where`)
    }
    
    func index< FindType : ILayout >(`as` type: FindType.Type, `where`: (FindType) -> Bool) -> Int? {
        return self.body.index(as: type, where: `where`)
    }
    
    func indices(_ content: [ILayout]) -> [Int] {
        return self.body.indices(content)
    }
    
    func indices< FindType : ILayout >(`as` type: FindType.Type, `where`: (FindType) -> Bool) -> [Int] {
        return self.body.indices(as: type, where: `where`)
    }

    func insert(_ content: ILayout, at index: Int) {
        return self.body.insert(content, at: index)
    }
    
    func insert(_ content: [ILayout], at index: Int) {
        return self.body.insert(content, at: index)
    }
    
    func delete(_ index: Int) {
        return self.body.delete(index)
    }
    
    func delete(_ content: ILayout) {
        return self.body.delete(content)
    }
    
    func delete(_ content: [ILayout]) {
        return self.body.delete(content)
    }
    
    func delete(_ range: Range< Int >) {
        return self.body.delete(range)
    }
    
}
