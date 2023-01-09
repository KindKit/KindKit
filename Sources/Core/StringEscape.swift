//
//  KindKit
//

import Foundation

public struct StringEscape : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension StringEscape {
    
    static let tab: Self = .init(rawValue: 1 << 0)
    static let newline: Self = .init(rawValue: 1 << 1)
    static let `return`: Self = .init(rawValue: 1 << 2)
    static let singleQuote: Self = .init(rawValue: 1 << 3)
    static let doubleQuote: Self = .init(rawValue: 1 << 4)
    
}
