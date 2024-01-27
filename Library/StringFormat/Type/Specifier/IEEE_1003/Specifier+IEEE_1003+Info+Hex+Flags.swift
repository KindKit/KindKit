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

extension Specifier.IEEE_1003.Info.Hex.Flags : Hashable {
}

extension Specifier.IEEE_1003.Info.Hex.Flags : Equatable {
}

extension Specifier.IEEE_1003.Info.Hex.Flags : Sendable {
}

public extension Specifier.IEEE_1003.Info.Hex.Flags {
    
    @inlinable
    static var uppercase: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var prefix: Self {
        return .init(rawValue: 1 << 1)
    }
    
}
