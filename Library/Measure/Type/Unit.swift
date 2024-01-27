//
//  KindKit
//

import KindNumeric
import KindLocalize
import KindString

public protocol Unit : Hashable, Equatable, Comparable, Sendable {
    
    associatedtype Finder : KindLocalize.Finder
    
    associatedtype Value : Hashable & Equatable & Comparable & Sendable & AddTrait & SubTrait & MulTrait & DivTrait
    
    static var finder: Finder { get }
    
    static var base: Self { get }
    
    var constant: Value { get }
    
    var coefficient: Value { get }
    
    var name: String { get }
    
}

// MARK: Comparable

public extension Unit {
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.constant < rhs.constant && lhs.coefficient < rhs.coefficient
    }
    
}
