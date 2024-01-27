//
//  KindKit
//

import KindProperty
import KindMonadicMacro

@Monadic
public protocol ValueFieldTrait : AnyObject where Self : Field {
    
    associatedtype Value : Equatable
    
    @MonadicField
    var value: Value { set get }
    
    var valueProperty: ValueProperty< Value > { get }
    
}

public extension ValueFieldTrait {
    
    @inlinable
    var value: Value {
        set { self.valueProperty.value = newValue }
        get { self.valueProperty.value }
    }
    
}
