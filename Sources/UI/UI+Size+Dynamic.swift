//
//  KindKit
//

import Foundation

public extension UI.Size {

    struct Dynamic : Equatable {
        
        public var width: Dimension
        public var height: Dimension
        
        @available(*, deprecated, renamed: "UI.Size.Dynamic.init(_:_:)")
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

public extension UI.Size.Dynamic {
    
    @inlinable
    var isStatic: Bool {
        return self.width.isStatic == true && self.height.isStatic == true
    }
    
}

public extension UI.Size.Dynamic {
    
    @inlinable
    func apply(
        available: Size,
        contentSize: Size
    ) -> Size {
        return self.apply(
            available: available,
            sizeWithWidth: { _ in contentSize },
            sizeWithHeight: { _ in contentSize },
            size: { contentSize }
        )
    }
    
    @inlinable
    func apply(
        available: Size,
        sizeWithWidth: (_ width: Double) -> Size,
        sizeWithHeight: (_ height: Double) -> Size,
        size: () -> Size
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
        case (.parent(let w), .content(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width) * w.value
            } else {
                rw = 0
            }
            rh = sizeWithWidth(rw).height * h.value
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
        case (.ratio(let w), .content(let h)):
            rh = size().height * h.value
            rw = rh * w.value
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
        case (.fixed(let w), .content(let h)):
            rw = w
            rh = size().height * h.value
        case (.content(let w), .parent(let h)):
            if available.height.isInfinite == false {
                rh = max(0, available.height) * h.value
            } else {
                rh = 0
            }
            rw = sizeWithHeight(rh).width * w.value
        case (.content(let w), .ratio(let h)):
            rw = size().width * w.value
            rh = rw * h.value
        case (.content(let w), .fixed(let h)):
            rw = sizeWithHeight(h).width * w.value
            rh = h
        case (.content(let w), .content(let h)):
            let s = size()
            rw = s.width * w.value
            rh = s.height * h.value
        }
        return .init(width: rw, height: rh)
    }
    
}
