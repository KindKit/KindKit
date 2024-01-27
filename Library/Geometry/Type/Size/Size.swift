//
//  KindKit
//

import KindNumeric

public struct Size {
    
    public var width: Coordinate
    public var height: Coordinate
    
    public init(
        width: Coordinate,
        height: Coordinate
    ) {
        self.width = width
        self.height = height
    }
    
    public init(
        both: Coordinate
    ) {
        self.width = both
        self.height = both
    }
    
    public init(
        _ point: Point
    ) {
        self.width = point.x
        self.height = point.y
    }
    
}

extension Size : Hashable {
}

extension Size : Equatable {
}

extension Size : Sendable {
}

public extension Size {
    
    @inlinable
    var swap: Self {
        return .init(
            width: self.height,
            height: self.width
        )
    }
    
    @inlinable
    var integral: Size {
        let n = self.normalized
        return .init(
            width: n.width.roundedUp,
            height: n.height.roundedUp
        )
    }
    
}

public extension Size {
    
    @inlinable
    func aspectFit(_ size: Self) -> Self {
        let w = size.width / self.width
        let h = size.height / self.height
        let scale = w.min(h)
        return .init(
            width: self.width * scale,
            height: self.height * scale
        )
    }
    
    @inlinable
    func aspectFill(_ size: Self) -> Self {
        let w = size.width / self.width
        let h = size.height / self.height
        let scale = w.max(h)
        return .init(
            width: self.width * scale,
            height: self.height * scale
        )
    }
    
    @inlinable
    func inset(
        horizontal: Coordinate,
        vertical: Coordinate
    ) -> Self {
        return .init(
            width: self.width.validated(modify: { $0 - horizontal }),
            height: self.height.validated(modify: { $0 - vertical })
        )
    }
    
    @inlinable
    func inset(all: Coordinate) -> Self {
        return self.inset(
            horizontal: all,
            vertical: all
        )
    }
    
    @inlinable
    func validated(default value: Self) -> Self {
        return .init(
            width: self.width.validated(default: value.width),
            height: self.height.validated(default: value.height)
        )
    }
    
    @inlinable
    func validated(defaultWidth width: () -> Coordinate) -> Self {
        return .init(
            width: self.width.validated(default: width),
            height: self.height
        )
    }
    
    @inlinable
    func validated(defaultWidth width: @autoclosure () -> Coordinate) -> Self {
        return .init(
            width: self.width.validated(default: width),
            height: self.height
        )
    }
    
    @inlinable
    func validated(defaultHeight height: () -> Coordinate) -> Self {
        return .init(
            width: self.width,
            height: self.height.validated(default: height)
        )
    }
    
    @inlinable
    func validated(defaultHeight height: @autoclosure () -> Coordinate) -> Self {
        return .init(
            width: self.width,
            height: self.height.validated(default: height)
        )
    }
    
}
