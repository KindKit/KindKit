//
//  KindKit
//

import Foundation

public struct EscapeMode : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension EscapeMode {
    
    static let tab: Self = .init(rawValue: 1 << 0)
    static let newline: Self = .init(rawValue: 1 << 1)
    static let `return`: Self = .init(rawValue: 1 << 2)
    static let singleQuote: Self = .init(rawValue: 1 << 3)
    static let doubleQuote: Self = .init(rawValue: 1 << 4)
    
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
