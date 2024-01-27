//
//  KindKit
//

public struct States : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension States : Equatable {
}

extension States : Hashable {
}

extension States : Sendable {
}

public extension States {
    
    @inlinable
    static var hightlighted: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var selected: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var disabled: Self {
        return .init(rawValue: 1 << 2)
    }
    
    @inlinable
    static var editing: Self {
        return .init(rawValue: 1 << 3)
    }
    
}
