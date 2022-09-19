//
//  KindKit
//

import Foundation

public extension UI.Size {

    enum Dynamic : Equatable {
        
        case `static`(_ value: UI.Size.Static)
        case morph(_ value: PercentFloat)
        case fit
        
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
        case .static(let value):
            return UI.Size.Static.apply(available: available, behaviour: value)
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
        case (.static(let w), .static(let h)):
            rw = UI.Size.Static.apply(available: available.width, behaviour: w) ?? 0
            rh = UI.Size.Static.apply(available: available.height, behaviour: h) ?? 0
        case (.static(let w), .morph(let h)):
            rw = UI.Size.Static.apply(available: available.width, behaviour: w) ?? 0
            let s = sizeWithWidth(rw)
            rh = s.height.isInfinite == false ? s.height * h.value : 0
        case (.static(let w), .fit):
            rw = UI.Size.Static.apply(available: available.width, behaviour: w) ?? 0
            let s = sizeWithWidth(rw)
            rh = s.height.isInfinite == false ? s.height : 0
        case (.morph(let w), .static(let h)):
            rh = UI.Size.Static.apply(available: available.height, behaviour: h) ?? 0
            let s = sizeWithHeight(rh)
            rw = s.width.isInfinite == false ? s.width * w.value : 0
        case (.morph(let w), .morph(let h)):
            let s = size()
            rw = s.width.isInfinite == false ? s.width * w.value : 0
            rh = s.height.isInfinite == false ? s.height * h.value : 0
        case (.morph(let w), .fit):
            let s = size()
            rw = s.width.isInfinite == false ? s.width * w.value : 0
            rh = s.height.isInfinite == false ? s.height : 0
        case (.fit, .static(let h)):
            rh = UI.Size.Static.apply(available: available.height, behaviour: h) ?? 0
            let s = sizeWithHeight(rh)
            rw = s.width.isInfinite == false ? s.width : 0
        case (.fit, .morph(let h)):
            let s = size()
            rw = s.width.isInfinite == false ? s.width : 0
            rh = s.height.isInfinite == false ? s.height * h.value : 0
        case (.fit, .fit):
            let s = size()
            rw = s.width.isInfinite == false ? s.width : 0
            rh = s.height.isInfinite == false ? s.height : 0
        }
        return Size(width: rw, height: rh)
    }
    
}
