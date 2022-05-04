//
//  KindKitCore
//

import Foundation
import KindKitMath

public enum DynamicSizeBehaviour : Equatable {
    case `static`(_ value: StaticSizeBehaviour)
    case morph(_ value: PercentFloat)
    case fit
}

public extension DynamicSizeBehaviour {
    
    @inlinable
    static func apply(
        available: Float,
        behaviour: DynamicSizeBehaviour,
        calculate: () -> Float
    ) -> Float? {
        switch behaviour {
        case .static(let value):
            return StaticSizeBehaviour.apply(available: available, behaviour: value)
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
        width: DynamicSizeBehaviour,
        height: DynamicSizeBehaviour,
        sizeWithWidth: (_ width: Float) -> SizeFloat,
        sizeWithHeight: (_ height: Float) -> SizeFloat,
        size: () -> SizeFloat
    ) -> SizeFloat {
        let rw, rh: Float
        switch (width, height) {
        case (.static(let w), .static(let h)):
            rw = StaticSizeBehaviour.apply(available: available.width, behaviour: w) ?? 0
            rh = StaticSizeBehaviour.apply(available: available.height, behaviour: h) ?? 0
        case (.static(let w), .morph(let h)):
            rw = StaticSizeBehaviour.apply(available: available.width, behaviour: w) ?? 0
            let s = sizeWithWidth(rw)
            rh = s.height.isInfinite == false ? s.height * h.value : 0
        case (.static(let w), .fit):
            rw = StaticSizeBehaviour.apply(available: available.width, behaviour: w) ?? 0
            let s = sizeWithWidth(rw)
            rh = s.height.isInfinite == false ? s.height : 0
        case (.morph(let w), .static(let h)):
            rh = StaticSizeBehaviour.apply(available: available.height, behaviour: h) ?? 0
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
            rh = StaticSizeBehaviour.apply(available: available.height, behaviour: h) ?? 0
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
