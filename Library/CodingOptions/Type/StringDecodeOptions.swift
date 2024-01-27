//
//  KindKit
//

public struct StringDecodeOptions : OptionSet, CodingOptions {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension StringDecodeOptions : DefaultCodingOptions {
    
    @inlinable
    public static var `default`: Self {
        return []
    }
    
}

public extension StringDecodeOptions {
    
    @inlinable
    static var nonEmpty: Self {
        return .init(rawValue: 1 << 0)
    }
    
}
