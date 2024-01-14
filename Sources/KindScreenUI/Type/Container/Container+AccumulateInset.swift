//
//  KindKit
//

import KindMath

public extension Container {

    struct AccumulateInset : Equatable {
        
        public var natural: Inset
        public var interactive: Inset
        
        public init(
            top: Double,
            left: Double,
            right: Double,
            bottom: Double
        ) {
            self.natural = .init(top: top, left: left, right: right, bottom: bottom)
            self.interactive = .init(top: top, left: left, right: right, bottom: bottom)
        }
        
        public init(
            horizontal: Double,
            vertical: Double
        ) {
            self.natural = .init(horizontal: horizontal, vertical: vertical)
            self.interactive = .init(horizontal: horizontal, vertical: vertical)
        }
        
        public init(
            _ base: Inset
        ) {
            self.natural = base
            self.interactive = base
        }
        
        public init(
            natural: Inset,
            interactive: Inset
        ) {
            self.natural = natural
            self.interactive = interactive
        }
        
        public init(
            top: Double,
            visibility: Double
        ) {
            self.natural = .init(top: top, left: 0, right: 0, bottom: 0)
            self.interactive = .init(top: top * visibility, left: 0, right: 0, bottom: 0)
        }
        
        public init(
            left: Double,
            visibility: Double
        ) {
            self.natural = .init(top: 0, left: left, right: 0, bottom: 0)
            self.interactive = .init(top: 0, left: left * visibility, right: 0, bottom: 0)
        }
        
        public init(
            right: Double,
            visibility: Double
        ) {
            self.natural = .init(top: 0, left: 0, right: right, bottom: 0)
            self.interactive = .init(top: 0, left: 0, right: right * visibility, bottom: 0)
        }
        
        public init(
            bottom: Double,
            visibility: Double
        ) {
            self.natural = .init(top: 0, left: 0, right: 0, bottom: bottom)
            self.interactive = .init(top: 0, left: 0, right: 0, bottom: bottom * visibility)
        }
        
    }

}

public extension Container.AccumulateInset {
    
    static var zero: Self {
        return .init(natural: .zero, interactive: .zero)
    }
    
}

public extension Container.AccumulateInset {
    
    @inlinable
    func min(_ other: Self) -> Self {
        return .init(
            natural: .init(
                top: Swift.min(self.natural.top, other.natural.top),
                left: Swift.min(self.natural.left, other.natural.left),
                right: Swift.min(self.natural.right, other.natural.right),
                bottom: Swift.min(self.natural.bottom, other.natural.bottom)
            ),
            interactive: .init(
                top: Swift.min(self.interactive.top, other.interactive.top),
                left: Swift.min(self.interactive.left, other.interactive.left),
                right: Swift.min(self.interactive.right, other.interactive.right),
                bottom: Swift.min(self.interactive.bottom, other.interactive.bottom)
            )
        )
    }
    
    @inlinable
    func max(_ other: Self) -> Self {
        return .init(
            natural: .init(
                top: Swift.max(self.natural.top, other.natural.top),
                left: Swift.max(self.natural.left, other.natural.left),
                right: Swift.max(self.natural.right, other.natural.right),
                bottom: Swift.max(self.natural.bottom, other.natural.bottom)
            ),
            interactive: .init(
                top: Swift.max(self.interactive.top, other.interactive.top),
                left: Swift.max(self.interactive.left, other.interactive.left),
                right: Swift.max(self.interactive.right, other.interactive.right),
                bottom: Swift.max(self.interactive.bottom, other.interactive.bottom)
            )
        )
    }
    
}

public extension Container.AccumulateInset {
    
    @inlinable
    static prefix func - (arg: Self) -> Self {
        return .init(
            natural: -arg.natural,
            interactive: -arg.interactive
        )
    }
    
    @inlinable
    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(
            natural: lhs.natural + rhs.natural,
            interactive: lhs.interactive + rhs.interactive
        )
    }
    
    @inlinable
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(
            natural: lhs.natural - rhs.natural,
            interactive: lhs.interactive - rhs.interactive
        )
    }
    
    @inlinable
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    static func * (lhs: Self, rhs: Self) -> Self {
        return .init(
            natural: lhs.natural * rhs.natural,
            interactive: lhs.interactive * rhs.interactive
        )
    }
    
    @inlinable
    static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    static func / (lhs: Self, rhs: Self) -> Self {
        return .init(
            natural: lhs.natural / rhs.natural,
            interactive: lhs.interactive / rhs.interactive
        )
    }
    
    @inlinable
    static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
}

extension Container.AccumulateInset : ILerpable {
    
    @inlinable
    public func lerp(_ to: Self, progress: Percent) -> Self {
        return .init(
            natural: self.natural.lerp(to.natural, progress: progress),
            interactive: self.interactive.lerp(to.interactive, progress: progress)
        )
    }
    
}
