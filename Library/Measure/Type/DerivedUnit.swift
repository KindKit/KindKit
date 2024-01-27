//
//  KindKit
//

import KindNumeric
import KindString

public protocol DerivedUnit : Unit {
    
    associatedtype SuperUnit : Unit where Value == SuperUnit.Value
    
    static var `super`: SuperUnit { get }
    
    init(`super`: SuperUnit)
    
}

public extension DerivedUnit {
    
    @inlinable
    var constant: Value {
        return Self.super.constant
    }
    
    @inlinable
    var coefficient: Value {
        return Self.super.coefficient
    }
    
    @inlinable
    var name: String {
        return Self.super.name
    }
    
}
