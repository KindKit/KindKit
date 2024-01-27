//
//  KindKit
//

public extension Push {
    
    struct Options : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Push.Options {
    
    static let useContentInset = Push.Options(rawValue: 1 << 0)
    
}
