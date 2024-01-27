//
//  KindKit
//

import Foundation

public struct TextUnderline : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension TextUnderline : Hashable {
}

extension TextUnderline : Equatable {
}

extension TextUnderline : Sendable {
}

public extension TextUnderline {
    
    @inlinable
    static var single: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var thick: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var double: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var patternDot: Self {
        return .init(rawValue: 1 << 3)
    }
    
    @inlinable
    static var patternDash: Self {
        return .init(rawValue: 1 << 4)
    }
    
    @inlinable
    static var patternDashDot: Self {
        return .init(rawValue: 1 << 5)
    }
    
    @inlinable
    static var patternDashDotDot: Self {
        return .init(rawValue: 1 << 6)
    }
    
    @inlinable
    static var byWord: Self {
        return .init(rawValue: 1 << 7)
    }

}
