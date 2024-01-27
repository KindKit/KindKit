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

extension Specifier.IEEE_1003.Info.FloatingPoint.Flags : Hashable {
}

extension Specifier.IEEE_1003.Info.FloatingPoint.Flags : Equatable {
}

extension Specifier.IEEE_1003.Info.FloatingPoint.Flags : Sendable {
}

public extension Specifier.IEEE_1003.Info.FloatingPoint.Flags {
    
    @inlinable
    static var uppercase: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var sign: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var zero: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var hex: Self {
        return .init(rawValue: 1 << 3)
    }
    
}
