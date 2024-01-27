//
//  KindKit
//

public struct DrawMode : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

extension DrawMode : Hashable {
}

extension DrawMode : Equatable {
}

extension DrawMode : Sendable {
}

public extension DrawMode {
    
    @inlinable
    static var fill: Self {
        return .init(rawValue: 1 << 0)
    }
    
    @inlinable
    static var stroke: Self {
        return .init(rawValue: 1 << 1)
    }
    
}
