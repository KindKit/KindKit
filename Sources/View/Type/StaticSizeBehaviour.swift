//
//  KindKitCore
//

import Foundation
import KindKitMath

public enum StaticSizeBehaviour : Equatable {
    case none
    case fixed(_ value: Float)
    case percent(_ value: PercentFloat)
    case fill
}

public extension StaticSizeBehaviour {
    
    @inlinable
    static func apply(
        available: Float,
        behaviour: StaticSizeBehaviour
    ) -> Float? {
        switch behaviour {
        case .none:
            return 0
        case .fixed(let value):
            return max(0, value)
        case .percent(let value):
            guard available.isInfinite == false else { return nil }
            return max(0, available * value.value)
        case .fill:
            guard available.isInfinite == false else { return nil }
            return max(0, available)
        }
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: StaticSizeBehaviour?,
        height: StaticSizeBehaviour?,
        aspectRatio: Float?
    ) -> SizeFloat {
        if let aspectRatio = aspectRatio {
            return Self.apply(
                available: available,
                width: width,
                height: height,
                aspectRatio: aspectRatio
            )
        }
        return Self.apply(
            available: available,
            width: width,
            height: height
        )
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: StaticSizeBehaviour?,
        height: StaticSizeBehaviour?,
        aspectRatio: Float
    ) -> SizeFloat {
        if let width = width {
            if let v = Self.apply(available: available.width, behaviour: width) {
                return Size(width: v, height: v / aspectRatio)
            }
        } else if let height = height {
            if let v = Self.apply(available: available.height, behaviour: height) {
                return Size(width: v * aspectRatio, height: v)
            }
        }
        return .zero
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: StaticSizeBehaviour?,
        height: StaticSizeBehaviour?
    ) -> SizeFloat {
        let w: Float
        if let width = width {
            w = Self.apply(available: available.width, behaviour: width) ?? 0
        } else {
            w = 0
        }
        let h: Float
        if let height = height {
            h = Self.apply(available: available.height, behaviour: height) ?? 0
        } else {
            h = 0
        }
        return Size(width: w, height: h)
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: StaticSizeBehaviour,
        height: StaticSizeBehaviour
    ) -> SizeFloat {
        return Size(
            width: Self.apply(available: available.width, behaviour: width) ?? 0,
            height: Self.apply(available: available.height, behaviour: height) ?? 0
        )
    }
    
}
