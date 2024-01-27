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

extension Specifier.IEEE_1003.Info.Number.Signed.Flags : Hashable {
}

extension Specifier.IEEE_1003.Info.Number.Signed.Flags : Equatable {
}

extension Specifier.IEEE_1003.Info.Number.Signed.Flags : Sendable {
}

public extension Specifier.IEEE_1003.Info.Number.Signed.Flags {
    
    @inlinable
    static var sign: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var zero: Self {
        return .init(rawValue: 1 << 1)
    }
    
}
