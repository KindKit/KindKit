//
//  KindKit
//

public struct Options : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension Options {
    
    @inlinable
    static var caseSensitive: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var `default`: Self {
        return [ .caseSensitive ]
    }

}
