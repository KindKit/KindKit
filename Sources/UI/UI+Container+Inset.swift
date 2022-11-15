//
//  KindKit
//

import Foundation

public extension UI.Container {

    struct Inset : Equatable {
        
        public var natural: InsetFloat
        public var interactive: InsetFloat
        
        public init(
            top: Float,
            left: Float,
            right: Float,
            bottom: Float
        ) {
            self.natural = .init(top: top, left: left, right: right, bottom: bottom)
            self.interactive = .init(top: top, left: left, right: right, bottom: bottom)
        }
        
        public init(
            horizontal: Float,
            vertical: Float
        ) {
            self.natural = .init(horizontal: horizontal, vertical: vertical)
            self.interactive = .init(horizontal: horizontal, vertical: vertical)
        }
        
        public init(
            _ base: InsetFloat
        ) {
            self.natural = base
            self.interactive = base
        }
        
        public init(
            natural: InsetFloat,
            interactive: InsetFloat
        ) {
            self.natural = natural
            self.interactive = interactive
        }
        
    }

}

public extension UI.Container.Inset {
    
    static let zero: Self = .init(natural: .zero, interactive: .zero)
    
}

public extension UI.Container.Inset {
    
    @inlinable
    func top(natural: Float, interactive: Float) -> Self {
        return .init(
            natural: .init(
                top: self.natural.top + natural,
                left: self.natural.left,
                right: self.natural.right,
                bottom: self.natural.bottom
            ),
            interactive: .init(
                top: self.interactive.top + interactive,
                left: self.interactive.left,
                right: self.interactive.right,
                bottom: self.interactive.bottom
            )
        )
    }
    
    @inlinable
    func left(natural: Float, interactive: Float) -> Self {
        return .init(
            natural: .init(
                top: self.natural.top,
                left: self.natural.left + natural,
                right: self.natural.right,
                bottom: self.natural.bottom
            ),
            interactive: .init(
                top: self.interactive.top,
                left: self.interactive.left + interactive,
                right: self.interactive.right,
                bottom: self.interactive.bottom
            )
        )
    }
    
    @inlinable
    func right(natural: Float, interactive: Float) -> Self {
        return .init(
            natural: .init(
                top: self.natural.top,
                left: self.natural.left,
                right: self.natural.right + natural,
                bottom: self.natural.bottom
            ),
            interactive: .init(
                top: self.interactive.top,
                left: self.interactive.left,
                right: self.interactive.right + interactive,
                bottom: self.interactive.bottom
            )
        )
    }
    
    @inlinable
    func bottom(natural: Float, interactive: Float) -> Self {
        return .init(
            natural: .init(
                top: self.natural.top,
                left: self.natural.left,
                right: self.natural.right,
                bottom: self.natural.bottom + natural
            ),
            interactive: .init(
                top: self.interactive.top,
                left: self.interactive.left,
                right: self.interactive.right,
                bottom: self.interactive.bottom + interactive
            )
        )
    }
    
    @inlinable
    func lerp(_ to: Self, progress: Float) -> Self {
        return .init(
            natural: self.natural.lerp(to.natural, progress: progress),
            interactive: self.interactive.lerp(to.interactive, progress: progress)
        )
    }
    
    @inlinable
    func lerp(_ to: Self, progress: PercentFloat) -> Self {
        return self.lerp(to, progress: progress.value)
    }
    
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

public extension UI.Container.Inset {
    
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
