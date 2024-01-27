//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct ArrangeRequest : Equatable {
    
    @MonadicField
    public let container: Rect
    
    @MonadicField
    public let available: Size
    
    public init(
        container: Rect
    ) {
        self.container = container
        self.available = container.size
    }
    
    public init(
        container: Rect,
        available: Size
    ) {
        self.container = container
        self.available = available
    }
    
    public init(
        container: Size,
        available: Size
    ) {
        self.container = .init(size: container)
        self.available = available
    }
    
    public init(
        _ request: SizeRequest
    ) {
        self.container = .init(size: request.container)
        self.available = request.available
    }
    
}

public extension ArrangeRequest {
    
    @inlinable
    var width: Coordinate {
        return self.available.width.validated(default: self.container.width)
    }
    
    @inlinable
    var height: Coordinate {
        return self.available.height.validated(default: self.container.height)
    }
    
    @inlinable
    var size: Size {
        return self.available.validated(default: self.container.size)
    }
    
}

public extension ArrangeRequest {
    
    @inlinable
    func `override`(width: Coordinate) -> Self {
        return .init(
            container: .init(
                origin: self.container.origin,
                size: .init(
                    width: width.validated(default: self.container.size.width),
                    height: self.container.size.height
                )
            ),
            available: .init(
                width: width,
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func `override`(height: Coordinate) -> Self {
        return .init(
            container: .init(
                origin: self.container.origin,
                size: .init(
                    width: self.container.size.width,
                    height: height.validated(default: self.container.size.width)
                )
            ),
            available: .init(
                width: self.available.width,
                height: height
            )
        )
    }
    
    @inlinable
    func `override`(width: Coordinate, height: Coordinate) -> Self {
        return .init(
            container: .init(
                origin: self.container.origin,
                size: .init(
                    width: width.validated(default: self.container.size.width),
                    height: height.validated(default: self.container.size.width)
                )
            ),
            available: .init(
                width: width,
                height: height
            )
        )
    }
    
    @inlinable
    func inset(_ inset: Inset) -> Self {
        return .init(
            container: self.container.inset(inset),
            available: self.available.inset(inset)
        )
    }
    
}
