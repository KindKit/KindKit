//
//  KindKit
//

public struct TextFlags : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension TextFlags : Hashable {
}

extension TextFlags : Equatable {
}

extension TextFlags : Sendable {
}

public extension TextFlags {
    
    @inlinable
    static var italic: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var bold: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var underline: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var strikethrough: Self {
        return .init(rawValue: 1 << 3)
    }

}
