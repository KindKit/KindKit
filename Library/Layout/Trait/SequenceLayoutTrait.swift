//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public protocol SequenceLayoutTrait : AnyObject {
    
    @MonadicField
    @MonadicField(builder: SequenceBuilder.self)
    var content: [any Layout] { set get }
    
    func contains(_ content: any Layout) -> Bool
    
    func index(_ content: any Layout) -> Int?
    
    func index(`where`: (any Layout) -> Bool) -> Int?
    
    func index< Find : Layout >(`as` type: Find.Type, `where`: (Find) -> Bool) -> Int?
    
    func indices(_ content: [any Layout]) -> [Int]
    
    func indices< Find : Layout >(`as` type: Find.Type, `where`: (Find) -> Bool) -> [Int]

    func insert(_ content: any Layout, at index: Int)
    
    func insert(_ content: [any Layout], at index: Int)
    
    func delete(_ index: Int)
    
    func delete(_ content: any Layout)
    
    func delete(_ content: [any Layout])
    
    func delete(_ range: Range< Int >)
    
}

public extension SequenceLayoutTrait where Self : CompositorTrait, Body : SequenceLayoutTrait {
    
    @inlinable
    var content: [any Layout] {
        set { self.body.content = newValue }
        get { self.body.content }
    }
    
    @inlinable
    func contains(_ content: any Layout) -> Bool {
        return self.body.contains(content)
    }
    
    @inlinable
    func index(_ content: any Layout) -> Int? {
        return self.body.index(content)
    }
    
    @inlinable
    func index(`where`: (any Layout) -> Bool) -> Int? {
        return self.body.index(where: `where`)
    }
    
    @inlinable
    func index< Find : Layout >(`as` type: Find.Type, `where`: (Find) -> Bool) -> Int? {
        return self.body.index(as: type, where: `where`)
    }
    
    @inlinable
    func indices(_ content: [any Layout]) -> [Int] {
        return self.body.indices(content)
    }
    
    @inlinable
    func indices< Find : Layout >(`as` type: Find.Type, `where`: (Find) -> Bool) -> [Int] {
        return self.body.indices(as: type, where: `where`)
    }

    @inlinable
    func insert(_ content: any Layout, at index: Int) {
        return self.body.insert(content, at: index)
    }
    
    @inlinable
    func insert(_ content: [any Layout], at index: Int) {
        return self.body.insert(content, at: index)
    }
    
    @inlinable
    func delete(_ index: Int) {
        return self.body.delete(index)
    }
    
    @inlinable
    func delete(_ content: any Layout) {
        return self.body.delete(content)
    }
    
    @inlinable
    func delete(_ content: [any Layout]) {
        return self.body.delete(content)
    }
    
    @inlinable
    func delete(_ range: Range< Int >) {
        return self.body.delete(range)
    }
    
}
