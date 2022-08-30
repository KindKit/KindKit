//
//  KindKitCore
//

import Foundation

public final class StringBuilder {
    
    private var _value: String
    
    public init(_ value: String = "") {
        self._value = value
    }
    
}

public extension StringBuilder {
    
    var string: String {
        return self._value
    }
    
    var count: Int {
        return self._value.count
    }
    
}

public extension StringBuilder {
    
    @discardableResult
    func append(
        _ value: String
    ) -> Self {
        self._value.append(value)
        return self
    }
    
    @discardableResult
    func append< Value : CustomStringConvertible >(
        _ value: Value
    ) -> Self {
        self._value.append(value.description)
        return self
    }
    
    @inlinable
    @discardableResult
    func append< Localized : IEnumLocalized >(
        localized: Localized
    ) -> Self {
        return self.append(localized.localized)
    }
    
    @inlinable
    @discardableResult
    func append< Formatter : IStringFormatter >(
        value: Formatter.InputType,
        formatter: Formatter
    ) -> Self {
        return self.append(formatter.format(value))
    }
    
    @discardableResult
    func append< Value : Sequence >(
        _ value: Value,
        separator: String
    ) -> Self where Value.Element == String {
        self._value.append(value.joined(separator: separator))
        return self
    }
    
    @discardableResult
    func append< Value : Sequence >(
        _ value: Value,
        map: (Value.Element) -> String,
        separator: String
    ) -> Self {
        self._value.append(value.map(map).joined(separator: separator))
        return self
    }
    
}
