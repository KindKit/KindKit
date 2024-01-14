//
//  KindKit
//

public struct RedirectOption : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension RedirectOption {
    
    static let enabled = RedirectOption(rawValue: 1 << 0)
    static let method = RedirectOption(rawValue: 1 << 1)
    static let authorization = RedirectOption(rawValue: 1 << 2)
    
}
