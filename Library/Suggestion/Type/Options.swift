//
//  KindKit
//

public struct Options : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension Options : Hashable {
}

extension Options : Equatable {
}

extension Options : Sendable {
}

public extension Options {
    
    @inlinable
    static var allowEmpty: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var caseSensitive: Self {
        return .init(rawValue: 1 << 1)
    }
    
    @inlinable
    static var `default`: Self {
        return [ .allowEmpty, .caseSensitive ]
    }

}
