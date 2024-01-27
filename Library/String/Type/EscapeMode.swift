//
//  KindKit
//

import Foundation

public struct EscapeMode : OptionSet, Sendable {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension EscapeMode {
    
    @inlinable
    static var tab: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var newline: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var `return`: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var singleQuote: Self {
        return .init(rawValue: 1 << 3)
    }
    
    @inlinable
    static var doubleQuote: Self {
        return .init(rawValue: 1 << 4)
    }
    
}

public extension EscapeMode {
    
    @inlinable
    func apply(_ string: String) -> String {
        var result = string
        if self.contains(.tab) == true {
            result = result.replacingOccurrences(of: "\t", with: "\\t")
        }
        if self.contains(.newline) == true {
            result = result.replacingOccurrences(of: "\n", with: "\\n")
        }
        if self.contains(.return) == true {
            result = result.replacingOccurrences(of: "\r", with: "\\r")
        }
        if self.contains(.singleQuote) == true {
            result = result.replacingOccurrences(of: "'", with: "\\'")
        }
        if self.contains(.doubleQuote) == true {
            result = result.replacingOccurrences(of: "\"", with: "\\\"")
        }
        return result
    }
    
}
