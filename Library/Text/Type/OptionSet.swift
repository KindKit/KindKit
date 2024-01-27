//
//  KindKit
//

public struct OptionSet : Swift.OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension OptionSet : Hashable {
}

extension OptionSet : Equatable {
}

extension OptionSet : Sendable {
}

public extension OptionSet {
    
    @inlinable
    static var style: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var flags: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var link: Self {
        return .init(rawValue: 1 << 2)
    }
    
}
