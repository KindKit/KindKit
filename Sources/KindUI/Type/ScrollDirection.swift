//
//  KindKit
//

public struct ScrollDirection : OptionSet {
    
    public typealias RawValue = UInt
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension ScrollDirection {
    
    static var horizontal = Self(rawValue: 1 << 0)
    static var vertical = Self(rawValue: 1 << 1)
    
}
