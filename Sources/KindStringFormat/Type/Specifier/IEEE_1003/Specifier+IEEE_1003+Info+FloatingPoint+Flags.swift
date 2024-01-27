//
//  KindKit
//

extension Specifier.IEEE_1003.Info.FloatingPoint {
    
    public struct Flags : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Specifier.IEEE_1003.Info.FloatingPoint.Flags {
    
    static let uppercase = Self(rawValue: 1 << 0)
    static let sign = Self(rawValue: 1 << 1)
    static let zero = Self(rawValue: 1 << 2)
    static let hex = Self(rawValue: 1 << 3)
    
}
