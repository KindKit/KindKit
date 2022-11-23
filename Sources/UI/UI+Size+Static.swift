//
//  KindKit
//

import Foundation

public extension UI.Size {
    
    struct Static : Equatable {
        
        public var width: Dimension
        public var height: Dimension
        
        @available(*, deprecated, renamed: "UI.Size.Static.init(_:_:)")
        public init(
            width: Dimension,
            height: Dimension
        ) {
            self.width = width
            self.height = height
        }
        
        public init(
            _ width: Dimension,
            _ height: Dimension
        ) {
            self.width = width
            self.height = height
        }
        
    }
    
}

public extension UI.Size.Static {
    
    @inlinable
    func apply(
        available: Size
    ) -> Size {
        let rw, rh: Double
        switch (self.width, self.height) {
        case (.parent(let w), .parent(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width) * w.value
            } else {
                rw = 0
            }
            if available.height.isInfinite == false {
                rh = max(0, available.height) * h.value
            } else {
                rh = 0
            }
        case (.parent(let w), .ratio(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width) * w.value
            } else {
                rw = 0
            }
            rh = rw * h.value
        case (.parent(let w), .fixed(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width) * w.value
            } else {
                rw = 0
            }
            rh = h
        case (.ratio(let w), .parent(let h)):
            if available.height.isInfinite == false {
                rh = max(0, available.height) * h.value
            } else {
                rh = 0
            }
            rw = rh * w.value
        case (.ratio, .ratio):
            rw = 0
            rh = 0
        case (.ratio(let w), .fixed(let h)):
            rw = h * w.value
            rh = h
        case (.fixed(let w), .parent(let h)):
            rw = w
            if available.height.isInfinite == false {
                rh = max(0, available.height) * h.value
            } else {
                rh = 0
            }
        case (.fixed(let w), .ratio(let h)):
            rw = w
            rh = w * h.value
        case (.fixed(let w), .fixed(let h)):
            rw = w
            rh = h
        }
        return .init(width: rw, height: rh)
    }
    
}
