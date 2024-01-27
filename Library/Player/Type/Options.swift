//
//  KindKit
//

#if os(macOS) || os(iOS)

public struct Options : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension Options {
    
    @inlinable
    static var autoplay: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var autorepeat: Self {
        return .init(rawValue: 1 << 1)
    }
    
}

#endif
