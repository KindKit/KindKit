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

extension Specifier.IEEE_1003.Info.Number.Unsigned.Flags : Hashable {
}

extension Specifier.IEEE_1003.Info.Number.Unsigned.Flags : Equatable {
}

extension Specifier.IEEE_1003.Info.Number.Unsigned.Flags : Sendable {
}

public extension Specifier.IEEE_1003.Info.Number.Unsigned.Flags {
    
    @inlinable
    static var zero: Self {
        return .init(rawValue: 1 << 0)
    }
    
}
