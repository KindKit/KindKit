//
//  KindKitCore
//

import Foundation

public extension String.StringInterpolation {
    
    @inlinable
    mutating func appendInterpolation< Localized : IEnumLocalized >(
        _ localized: Localized
    ) {
        self.appendLiteral(localized.localized)
    }
    
    @inlinable
    mutating func appendInterpolation< FormatterType : IStringFormatter >(
        _ value: FormatterType.InputType,
        formatter: FormatterType
    ) {
        self.appendLiteral(formatter.format(value))
    }
    
    @inlinable
    mutating func appendInterpolation(
        if condition: @autoclosure () -> Bool,
        then: @autoclosure () -> StringLiteralType
    ) {
        if condition() == true {
            self.appendLiteral(then())
        }
    }
    
    @inlinable
    mutating func appendInterpolation(
        if condition: @autoclosure () -> Bool,
        then: @autoclosure () -> StringLiteralType,
        else: @autoclosure () -> StringLiteralType
    ) {
        if condition() == true {
            self.appendLiteral(then())
        } else {
            self.appendLiteral(`else`())
        }
    }
    
}
