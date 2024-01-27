//
//  KindKit
//

public struct Percent {
    
    public var value: Double
    
    public init(value: Double) {
        self.value = value
    }
    
    @inlinable
    public init< Input : ToNumberTrait >(_ value: Input) {
        self.init(value: value.to())
    }
    
    @inlinable
    public init< Input : ToNumberTrait & DivTrait >(_ current: Input, from: Input) {
        self.init(value: current.dividing(this: from).to())
    }
    
}

extension Percent : Hashable {
}

extension Percent : Equatable {
}

extension Percent : Sendable {
}

public extension Percent {
    
    @inlinable
    static var half: Self {
        return .init(value: 0.5)
    }
    
    @inlinable
    var isHalf: Bool {
        return self.isNearEqual(.half)
    }
    
}
