//
//  KindKit
//

import KindProperty
import KindMonadicMacro

@Monadic
public protocol SelectedFieldTrait : AnyObject where Self : Field {
    
    @MonadicField
    var isSelected: Bool { set get }
    
    var selectedProperty: ValueProperty< Bool > { get }
    
}

public extension SelectedFieldTrait {
    
    @inlinable
    var isSelected: Bool {
        set { self.selectedProperty.value = newValue }
        get { self.selectedProperty.value }
    }
    
}
