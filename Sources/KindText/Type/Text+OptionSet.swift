//
//  KindKit
//

extension Text {
    
    public struct OptionSet : Swift.OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Text.OptionSet {
    
    static let style = Self(rawValue: 1 << 0)
    static let flags = Self(rawValue: 1 << 1)
    static let link = Self(rawValue: 1 << 2)
    
}
