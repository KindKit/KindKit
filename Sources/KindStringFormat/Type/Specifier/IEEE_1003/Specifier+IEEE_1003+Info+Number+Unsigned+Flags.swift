//
//  KindKit
//

extension Specifier.IEEE_1003.Info.Number.Unsigned {
    
    public struct Flags : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Specifier.IEEE_1003.Info.Number.Unsigned.Flags {
    
    static let zero = Self(rawValue: 1 << 0)
    
}
