//
//  KindKit
//

import KindProperty
import KindMonadicMacro

@Monadic
public protocol MandatoryFieldTrait : AnyObject where Self : Field {
    
    @MonadicField
    var isMandatory: Bool { set get }
    
    var mandatoryProperty: ValueProperty< Bool > { get }
    
}

public extension MandatoryFieldTrait {
    
    @inlinable
    var isMandatory: Bool {
        set { self.mandatoryProperty.value = newValue }
        get { self.mandatoryProperty.value }
    }
    
}
