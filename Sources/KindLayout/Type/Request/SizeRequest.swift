//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct SizeRequest : Equatable {
    
    @KindMonadicProperty
    public let container: Size
    
    @KindMonadicProperty
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
    var width: Double {
        return self.available.width.normalized(self.container.width)
    }
    
    @inlinable
    var height: Double {
        return self.available.height.normalized(self.container.height)
    }
    
    @inlinable
    var size: Size {
        return self.available.normalized(self.container)
    }
    
}

public extension SizeRequest {
    
    @inlinable
    func `override`(width: Double) -> Self {
        return .init(
            container: .init(
                width: width.normalized(self.container.width),
                height: self.container.height
            ),
            available: .init(
                width: width,
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func `override`(height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: height.normalized(self.container.width)
            ),
            available: .init(
                width: self.available.width,
                height: height
            )
        )
    }
    
    @inlinable
    func `override`(width: Double, height: Double) -> Self {
        return .init(
            container: .init(
                width: width.normalized(self.container.width),
                height: height.normalized(self.container.width)
            ),
            available: .init(
                width: width,
                height: height
            )
        )
    }
    
    @inlinable
    func increase(width: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width + width,
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.updating({ $0 + width }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func increase(height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: self.container.height + height
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.updating({ $0 + height })
            )
        )
    }
    
    @inlinable
    func increase(width: Double, height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width + width,
                height: self.container.height + height
            ),
            available: .init(
                width: self.available.width.updating({ $0 + width }),
                height: self.available.height.updating({ $0 + height })
            )
        )
    }
    
    @inlinable
    func decrease(width: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width - width,
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.updating({ $0 - width }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func decrease(height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: self.container.height - height
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.updating({ $0 - height })
            )
        )
    }
    
    @inlinable
    func decrease(width: Double, height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width - width,
                height: self.container.height - height
            ),
            available: .init(
                width: self.available.width.updating({ $0 - width }),
                height: self.available.height.updating({ $0 - height })
            )
        )
    }
    
    @inlinable
    func min(width: Double) -> Self {
        return .init(
            container: .init(
                width: Swift.min(self.container.width, width),
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.updating({ Swift.min($0, width) }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func min(height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: Swift.min(self.container.height, height)
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.updating({ Swift.min($0, height) })
            )
        )
    }
    
    @inlinable
    func min(width: Double, height: Double) -> Self {
        return .init(
            container: .init(
                width: Swift.min(self.container.width, width),
                height: Swift.min(self.container.height, height)
            ),
            available: .init(
                width: self.available.width.updating({ Swift.min($0, width) }),
                height: self.available.height.updating({ Swift.min($0, height) })
            )
        )
    }
    
    @inlinable
    func max(width: Double) -> Self {
        return .init(
            container: .init(
                width: Swift.max(self.container.width, width),
                height: self.container.height
            ),
            available: .init(
                width: self.available.width.updating({ Swift.max($0, width) }),
                height: self.available.height
            )
        )
    }
    
    @inlinable
    func max(height: Double) -> Self {
        return .init(
            container: .init(
                width: self.container.width,
                height: Swift.max(self.container.height, height)
            ),
            available: .init(
                width: self.available.width,
                height: self.available.height.updating({ Swift.max($0, height) })
            )
        )
    }
    
    @inlinable
    func max(width: Double, height: Double) -> Self {
        return .init(
            container: .init(
                width: Swift.max(self.container.width, width),
                height: Swift.max(self.container.height, height)
            ),
            available: .init(
                width: self.available.width.updating({ Swift.max($0, width) }),
                height: self.available.height.updating({ Swift.max($0, height) })
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
