//
//  KindKit
//

extension Specifier.IEEE_1003.Info.Number.Signed {
    
    public struct Flags : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Specifier.IEEE_1003.Info.Number.Signed.Flags {
    
    static let sign = Self(rawValue: 1 << 0)
    static let zero = Self(rawValue: 1 << 1)
    
}
