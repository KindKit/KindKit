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
    
    static let inline = Self(rawValue: 1 << 0)
    
}
