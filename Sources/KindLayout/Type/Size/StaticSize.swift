//
//  KindKit
//

import KindMath

public struct StaticSize : Equatable {
    
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

public extension StaticSize {
    
    static var fill: Self {
        return .init(width: .fill, height: .fill)
    }
    
}

public extension StaticSize {
    
    func resolve(by request: SizeRequest) -> Size {
        switch (self.width, self.height) {
        case (.fixed(let w), .fixed(let h)):
            return .init(width: w, height: h)
        case (.fixed(let w), .ratio(let h)):
            return .init(width: w, height: w * h)
        case (.fixed(let w), .fill):
            let h = request.available.height.normalized(request.container.height)
            return .init(width: w, height: h)
        case (.ratio(let w), .fixed(let h)):
            return .init(width: h * w, height: h)
        case (.ratio, .ratio):
            return .zero
        case (.ratio(let w), .fill):
            let h = request.available.height.normalized(request.container.height)
            return .init(width: h * w, height: h)
        case (.fill, .fixed(let h)):
            let w = request.available.width.normalized(request.container.width)
            return .init(width: w, height: h)
        case (.fill, .ratio(let h)):
            let w = request.available.width.normalized(request.container.width)
            return .init(width: w, height: w * h)
        case (.fill, .fill):
            let w = request.available.width.normalized(request.container.width)
            let h = request.available.height.normalized(request.container.height)
            return .init(width: w, height: h)
        }
    }
    
}

extension StaticSize : IMapable {
}
