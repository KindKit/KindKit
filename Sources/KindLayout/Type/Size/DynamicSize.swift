//
//  KindKit
//

import KindMath

public struct DynamicSize : Equatable {
    
    public var width: Axis
    public var height: Axis
    
    public init(
        width: Axis,
        height: Axis
    ) {
        self.width = width
        self.height = height
    }
    
}

public extension DynamicSize {
    
    static var fill: Self {
        return .init(width: .fill, height: .fill)
    }
    
    static var fit: Self {
        return .init(width: .fit, height: .fit)
    }
    
}

public extension DynamicSize {
    
    @inlinable
    var isStatic: Bool {
        return self.width.isStatic == true && self.height.isStatic == true
    }
    
}

public extension DynamicSize {
    
    func resolve(
        by container: Size
    ) -> Size {
        switch (self.width, self.height) {
        case (.fixed(let w), .fixed(let h)):
            return .init(width: w, height: h)
        case (.fixed(let w), .fill):
            return .init(width: w, height: container.height)
        case (.fixed(let w), .fit):
            return .init(width: w, height: .infinity)
        case (.fill, .fixed(let h)):
            return .init(width: container.width, height: h)
        case (.fill, .fill):
            return container
        case (.fill, .fit):
            return .init(width: container.width, height: .infinity)
        case (.fit, .fixed(let h)):
            return .init(width: .infinity, height: h)
        case (.fit, .fill):
            return .init(width: .infinity, height: container.height)
        case (.fit, .fit):
            return .infinity
        }
    }
    
    func resolve(
        by request: SizeRequest,
        calculate: (Size) -> Size
    ) -> Size {
        switch (self.width, self.height) {
        case (.fixed(let w), .fixed(let h)):
            return .init(width: w, height: h)
        case (.fixed(let w), .fill):
            let h = request.available.height.normalized(request.container.height)
            return .init(width: w, height: h)
        case (.fixed(let w), .fit):
            let h = request.available.height
            return calculate(.init(width: w, height: h))
        case (.fill, .fixed(let h)):
            let w = request.available.width.normalized(request.container.width)
            return .init(width: w, height: h)
        case (.fill, .fill):
            let w = request.available.width.normalized(request.container.width)
            let h = request.available.height.normalized(request.container.height)
            return .init(width: w, height: h)
        case (.fill, .fit):
            let w = request.available.width.normalized(request.container.width)
            let h = request.available.height
            let s = calculate(.init(width: w, height: h))
            return .init(width: w, height: s.height)
        case (.fit, .fixed(let h)):
            let w = request.available.width
            let s = calculate(.init(width: w, height: h))
            return .init(width: s.width, height: h)
        case (.fit, .fill):
            let w = request.available.width
            let h = request.available.height.normalized(request.container.height)
            let s = calculate(.init(width: w, height: h))
            return .init(width: s.width, height: h)
        case (.fit, .fit):
            return calculate(request.available)
        }
    }
    
    func resolve(
        by request: SizeRequest,
        withWidth: (Double, Double) -> Size,
        withHeight: (Double, Double) -> Size,
        withSize: (Size) -> Size
    ) -> Size {
        switch (self.width, self.height) {
        case (.fixed(let w), .fixed(let h)):
            return .init(width: w, height: h)
        case (.fixed(let w), .fill):
            let h = request.available.height.normalized(request.container.height)
            return .init(width: w, height: h)
        case (.fixed(let w), .fit):
            return withWidth(w, request.available.height)
        case (.fill, .fixed(let h)):
            let w = request.available.width.normalized(request.container.width)
            return .init(width: w, height: h)
        case (.fill, .fill):
            let w = request.available.width.normalized(request.container.width)
            let h = request.available.height.normalized(request.container.height)
            return .init(width: w, height: h)
        case (.fill, .fit):
            let w = request.available.width.normalized(request.container.width)
            return withWidth(w, request.available.height)
        case (.fit, .fixed(let h)):
            return withHeight(h, request.available.width)
        case (.fit, .fill):
            let h = request.available.height.normalized(request.container.height)
            return withHeight(h, request.available.width)
        case (.fit, .fit):
            return withSize(request.available.normalized(request.container))
        }
    }
    
}

extension DynamicSize : IMapable {
}
