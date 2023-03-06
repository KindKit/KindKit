//
//  KindKit
//

import Foundation

public final class StringBuilder {
    
    public var string: String
    
    public init(_ value: String = "") {
        self.string = value
    }
    
}

public extension StringBuilder {
    
    var count: Int {
        return self.string.count
    }
    
}

public extension StringBuilder {
    
    @inlinable
    @discardableResult
    func newline() -> Self {
        self.string.append("\n")
        return self
    }
    
    @inlinable
    @discardableResult
    func append(
        _ value: String
    ) -> Self {
        self.string.append(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func append< Value : CustomStringConvertible >(
        _ value: Value
    ) -> Self {
        self.string.append(value.description)
        return self
    }
    
    @inlinable
    @discardableResult
    func append(
        _ value: Character,
        repeating: Int
    ) -> Self {
        if repeating > 0 {
            self.string.append(String(repeating: value, count: repeating))
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func append(
        _ value: String,
        repeating: Int
    ) -> Self {
        if repeating > 0 {
            self.string.append(String(repeating: value, count: repeating))
        }
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
    
    @inlinable
    @discardableResult
    func append< Value : Sequence >(
        _ value: Value,
        separator: String
    ) -> Self where Value.Element == String {
        self.append(value.joined(separator: separator))
        return self
    }
    
    @inlinable
    @discardableResult
    func append< Value : Sequence >(
        _ value: Value,
        map: (Value.Element) -> String,
        separator: String
    ) -> Self {
        self.append(value.map(map).joined(separator: separator))
        return self
    }
    
}
