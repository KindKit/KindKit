//
//  KindKit
//

public struct SequenceCodingOptions : OptionSet, CodingOptions {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension SequenceCodingOptions : DefaultCodingOptions {
    
    @inlinable
    public static var `default`: Self {
        return []
    }
    
}

public extension SequenceCodingOptions {
    
    @inlinable
    static var nonEmpty: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var skipInvalid: Self {
        return .init(rawValue: 1 << 1)
    }
    
}
