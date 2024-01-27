//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public struct SizeRequest : Equatable {
    
    @MonadicField
    public let container: Size
    
    @MonadicField
    public let available: Size
    
    public init(
        container: Size,
        available: Size
    ) {
        self.container = container
        self.available = available
    }
    
    public init(
        size: Size
    ) {
        self.container = size
        self.available = size
    }
    
    public init(
        _ arrange: ArrangeRequest
    ) {
        self.container = arrange.container.size
        self.available = arrange.available
    }
    
}

public extension SizeRequest {
    
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
        return self.available.validated(default: self.container)
    }
    
}

public extension SizeRequest {
    
    @inlinable
    func `override`(width: Coordinate) -> Self {
        return .init(
            container: .init(
                width: width.validated(default: self.container.width),
                height: self.container.height
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
                width: self.container.width,
                height: height.validated(default: self.container.width)
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
                width: width.validated(default: self.container.width),
                height: height.validated(default: self.container.width)
            ),
            available: .init(
                width: width,
                height: height
            )
        )
    }
    
    @inlinable
    func increase(width: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width + width,
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0 + width }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func increase(height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: self.container.height + height
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.validated(modify: { $0 + height })
            )
        )
    }
    
    @inlinable
    func increase(width: Coordinate, height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width + width,
                height: self.container.height + height
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0 + width }),
                height: self.available.height.validated(modify: { $0 + height })
            )
        )
    }
    
    @inlinable
    func decrease(width: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width - width,
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0 - width }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func decrease(height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: self.container.height - height
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.validated(modify: { $0 - height })
            )
        )
    }
    
    @inlinable
    func decrease(width: Coordinate, height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width - width,
                height: self.container.height - height
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0 - width }),
                height: self.available.height.validated(modify: { $0 - height })
            )
        )
    }
    
    @inlinable
    func min(width: Coordinate) -> Self {
        return .init(
            container: .init(
                width: Swift.min(self.container.width, width),
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0.min(width) }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func min(height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: Swift.min(self.container.height, height)
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.validated(modify: { $0.min(height) })
            )
        )
    }
    
    @inlinable
    func min(width: Coordinate, height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: Swift.min(self.container.width, width),
                height: Swift.min(self.container.height, height)
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0.min(width) }),
                height: self.available.height.validated(modify: { $0.min(height) })
            )
        )
    }
    
    @inlinable
    func max(width: Coordinate) -> Self {
        return .init(
            container: .init(
                width: Swift.max(self.container.width, width),
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0.max(width) }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func max(height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: Swift.max(self.container.height, height)
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.validated(modify: { $0.max(height) })
            )
        )
    }
    
    @inlinable
    func max(width: Coordinate, height: Coordinate) -> Self {
        return .init(
            container: .init(
                width: Swift.max(self.container.width, width),
                height: Swift.max(self.container.height, height)
            ),
            available: .init(
                width: self.available.width.validated(modify: { $0.max(width) }),
                height: self.available.height.validated(modify: { $0.max(height) })
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
