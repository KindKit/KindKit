//
//  KindKit
//

extension Specifier.IEEE_1003.Info.Hex {
    
    public struct Flags : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Specifier.IEEE_1003.Info.Hex.Flags {
    
    static let uppercase = Self(rawValue: 1 << 0)
    static let prefix = Self(rawValue: 1 << 1)
    
}
