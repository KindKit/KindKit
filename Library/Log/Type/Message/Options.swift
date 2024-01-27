//
//  KindKit
//

public struct Options : OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}

public extension Options {
    
    @inlinable
    static var pretty: Self {
        return .init(rawValue: 1 << 0)
    }
    
}
