//
//  KindKit
//

import KindEvent

public final class AnyProperty< Value > : Property {
    
    public typealias Value = Value
    
    public var scope: Scope {
        return self._property.scope
    }
    
    public var value: Value {
        return self._property.value as! Value
    }
    
    public let onChanged: Signal< Void, Change< Value > >
    
    private let _property: any Property
    
    public init< Property : KindProperty.Property >(_ property: Property) where Property.Value == Value {
        self._property = property
        self.onChanged = property.onChanged
    }
    
    public func requestChange() {
        self._property.requestChange()
    }
    
}
