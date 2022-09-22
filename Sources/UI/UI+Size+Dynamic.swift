//
//  KindKit
//

import Foundation

public extension UI.Size {

    enum Dynamic : Equatable {
        
        case fill
        case percent(PercentFloat)
        case fixed(Float)
        case morph(PercentFloat)
        case fit
        
    }
    
}

public extension UI.Size.Dynamic {
    
    @available(iOS, deprecated: 10)
    static func `static`(_ size: UI.Size.Static) -> UI.Size.Dynamic {
        switch size {
        case .fill: return .fill
        case .percent(let value): return .percent(value)
        case .fixed(let value): return .fixed(value)
        }
    }
    
}

public extension UI.Size.Dynamic {
    
    var isStatic: Bool {
        switch self {
        case .fill, .percent, .fixed: return true
        case .morph, .fit: return false
        }
    }
    
}

public extension UI.Size.Dynamic {
    
    @inlinable
    static func apply(
        available: Float,
        behaviour: UI.Size.Dynamic,
        calculate: () -> Float
    ) -> Float? {
        switch behaviour {
        case .fixed(let value):
            return UI.Size.Static.apply(available: available, behaviour: .fixed(value))
        case .percent(let value):
            return UI.Size.Static.apply(available: available, behaviour: .percent(value))
        case .fill:
            return UI.Size.Static.apply(available: available, behaviour: .fill)
        case .morph(let percent):
            let r = calculate()
            guard r.isInfinite == false else { return nil }
            return max(0, r * percent.value)
        case .fit:
            let r = calculate()
            guard r.isInfinite == false else { return nil }
            return max(0, r)
        }
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: UI.Size.Dynamic,
        height: UI.Size.Dynamic,
        sizeWithWidth: (_ width: Float) -> SizeFloat,
        sizeWithHeight: (_ height: Float) -> SizeFloat,
        size: () -> SizeFloat
    ) -> SizeFloat {
        let rw, rh: Float
        switch (width, height) {
        case (.fill, fill):
            if available.width.isInfinite == false {
                rw = max(0, available.width)
            } else {
                rw = 0
            }
            if available.height.isInfinite == false {
                rh = max(0, available.height)
            } else {
                rh = 0
            }
        case (.fixed(let w), fill):
            rw = max(0, w)
            if available.height.isInfinite == false {
                rh = max(0, available.height)
            } else {
                rh = 0
            }
        case (.percent(let w), fill):
            if available.width.isInfinite == false {
                rw = max(0, available.width * w.value)
            } else {
                rw = 0
            }
            if available.height.isInfinite == false {
                rh = max(0, available.height)
            } else {
                rh = 0
            }
        case (.morph(let w), fill):
            if available.height.isInfinite == false {
                rh = max(0, available.height)
            } else {
                rh = 0
            }
            let s = sizeWithHeight(rh)
            if s.width.isInfinite == false {
                rw = max(0, s.width * w.value)
            } else {
                rw = 0
            }
        case (.fit, fill):
            if available.height.isInfinite == false {
                rh = max(0, available.height)
            } else {
                rh = 0
            }
            let s = sizeWithHeight(rh)
            if s.width.isInfinite == false {
                rw = s.width
            } else {
                rw = 0
            }
        case (.fill, .fixed(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width)
            } else {
                rw = 0
            }
            rh = max(0, h)
        case (.fixed(let w), .fixed(let h)):
            rw = max(0, w)
            rh = max(0, h)
        case (.percent(let w), .fixed(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width * w.value)
            } else {
                rw = 0
            }
            rh = max(0, h)
        case (.morph(let w), .fixed(let h)):
            rh = max(0, h)
            let s = sizeWithHeight(rh)
            if s.width.isInfinite == false {
                rw = max(0, s.width * w.value)
            } else {
                rw = 0
            }
        case (.fit, .fixed(let h)):
            rh = max(0, h)
            let s = sizeWithHeight(rh)
            if s.width.isInfinite == false {
                rw = s.width
            } else {
                rw = 0
            }
        case (.fill, .percent(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width)
            } else {
                rw = 0
            }
            if available.height.isInfinite == false {
                rh = max(0, available.height * h.value)
            } else {
                rh = 0
            }
        case (.fixed(let w), .percent(let h)):
            rw = max(0, w)
            if available.height.isInfinite == false {
                rh = max(0, available.height * h.value)
            } else {
                rh = 0
            }
        case (.percent(let w), .percent(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width * w.value)
            } else {
                rw = 0
            }
            if available.height.isInfinite == false {
                rh = max(0, available.height * h.value)
            } else {
                rh = 0
            }
        case (.morph(let w), .percent(let h)):
            if available.height.isInfinite == false {
                rh = max(0, available.height * h.value)
            } else {
                rh = 0
            }
            let s = sizeWithHeight(rh)
            if s.width.isInfinite == false {
                rw = max(0, s.width * w.value)
            } else {
                rw = 0
            }
        case (.fit, .percent(let h)):
            if available.height.isInfinite == false {
                rh = max(0, available.height * h.value)
            } else {
                rh = 0
            }
            let s = sizeWithHeight(rh)
            if s.width.isInfinite == false {
                rw = s.width
            } else {
                rw = 0
            }
        case (.fill, .morph(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width)
            } else {
                rw = 0
            }
            let s = sizeWithWidth(rw)
            if s.height.isInfinite == false {
                rh = max(0, s.height * h.value)
            } else {
                rh = 0
            }
        case (.fixed(let w), .morph(let h)):
            rw = max(0, w)
            let s = sizeWithWidth(rw)
            if s.height.isInfinite == false {
                rh = max(0, s.height * h.value)
            } else {
                rh = 0
            }
        case (.percent(let w), .morph(let h)):
            if available.width.isInfinite == false {
                rw = max(0, available.width * w.value)
            } else {
                rw = 0
            }
            let s = sizeWithWidth(rw)
            if s.height.isInfinite == false {
                rh = max(0, s.height * h.value)
            } else {
                rh = 0
            }
        case (.morph(let w), .morph(let h)):
            let s = size()
            if s.width.isInfinite == false {
                rw = max(0, s.width * w.value)
            } else {
                rw = 0
            }
            if s.height.isInfinite == false {
                rh = max(0, s.height * h.value)
            } else {
                rh = 0
            }
        case (.fit, .morph(let h)):
            let s = size()
            if s.width.isInfinite == false {
                rw = s.width
            } else {
                rw = 0
            }
            if s.height.isInfinite == false {
                rh = max(0, s.height * h.value)
            } else {
                rh = 0
            }
        case (.fill, fit):
            if available.width.isInfinite == false {
                rw = max(0, available.width)
            } else {
                rw = 0
            }
            let s = sizeWithWidth(rw)
            if s.height.isInfinite == false {
                rh = s.height
            } else {
                rh = 0
            }
        case (.fixed(let w), fit):
            rw = max(0, w)
            let s = sizeWithWidth(rw)
            if s.height.isInfinite == false {
                rh = s.height
            } else {
                rh = 0
            }
        case (.percent(let w), fit):
            if available.width.isInfinite == false {
                rw = max(0, available.width * w.value)
            } else {
                rw = 0
            }
            let s = sizeWithWidth(rw)
            if s.height.isInfinite == false {
                rh = s.height
            } else {
                rh = 0
            }
        case (.morph(let w), fit):
            let s = size()
            if s.width.isInfinite == false {
                rw = max(0, s.width * w.value)
            } else {
                rw = 0
            }
            if s.height.isInfinite == false {
                rh = s.height
            } else {
                rh = 0
            }
        case (.fit, fit):
            let s = size()
            if s.width.isInfinite == false {
                rw = s.width
            } else {
                rw = 0
            }
            if s.height.isInfinite == false {
                rh = s.height
            } else {
                rh = 0
            }
        }
        return Size(width: rw, height: rh)
    }
    
}
