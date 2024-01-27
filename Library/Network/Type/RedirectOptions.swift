//
//  KindKit
//

public struct RedirectOption : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension RedirectOption : Hashable {
}

extension RedirectOption : Equatable {
}

extension RedirectOption : Sendable {
}

public extension RedirectOption {
    
    @inlinable
    static var enabled: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var method: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var authorization: Self {
        return .init(rawValue: 1 << 2)
    }
    
}
