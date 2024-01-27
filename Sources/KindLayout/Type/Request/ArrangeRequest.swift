//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public struct ArrangeRequest : Equatable {
    
    @KindMonadicProperty
    public let container: Rect
    
    @KindMonadicProperty
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
    var width: Double {
        return self.available.width.normalized(self.container.width)
    }
    
    @inlinable
    var height: Double {
        return self.available.height.normalized(self.container.height)
    }
    
    @inlinable
    var size: Size {
        return self.available.normalized(self.container.size)
    }
    
}

public extension ArrangeRequest {
    
    @inlinable
    func `override`(width: Double) -> Self {
        return .init(
            container: .init(
                origin: self.container.origin,
                size: .init(
                    width: width.normalized(self.container.size.width),
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
    func `override`(height: Double) -> Self {
        return .init(
            container: .init(
                origin: self.container.origin,
                size: .init(
                    width: self.container.size.width,
                    height: height.normalized(self.container.size.width)
                )
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
                origin: self.container.origin,
                size: .init(
                    width: width.normalized(self.container.size.width),
                    height: height.normalized(self.container.size.width)
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
