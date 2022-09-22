//
//  KindKit
//

import Foundation

public extension UI.Size {

    enum Static : Equatable {
        
        case fill
        case percent(PercentFloat)
        case fixed(Float)
        
    }
    
}

public extension UI.Size.Static {
    
    @inlinable
    static func apply(
        available: Float,
        behaviour: UI.Size.Static
    ) -> Float {
        switch behaviour {
        case .fill:
            guard available.isInfinite == false else { return 0 }
            return max(0, available)
        case .fixed(let value):
            return max(0, value)
        case .percent(let value):
            guard available.isInfinite == false else { return 0 }
            return max(0, available * value.value)
        }
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: UI.Size.Static?,
        height: UI.Size.Static?,
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
        width: UI.Size.Static?,
        height: UI.Size.Static?,
        aspectRatio: Float
    ) -> SizeFloat {
        if let width = width {
            let w = Self.apply(available: available.width, behaviour: width)
            if w > .leastNonzeroMagnitude {
                return Size(width: w, height: w / aspectRatio)
            }
        } else if let height = height {
            let h = Self.apply(available: available.height, behaviour: height)
            if h > .leastNonzeroMagnitude {
                return Size(width: h * aspectRatio, height: h)
            }
        }
        return .zero
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: UI.Size.Static?,
        height: UI.Size.Static?
    ) -> SizeFloat {
        let w: Float
        if let width = width {
            w = Self.apply(available: available.width, behaviour: width)
        } else {
            w = 0
        }
        let h: Float
        if let height = height {
            h = Self.apply(available: available.height, behaviour: height)
        } else {
            h = 0
        }
        return Size(width: w, height: h)
    }
    
    @inlinable
    static func apply(
        available: SizeFloat,
        width: UI.Size.Static,
        height: UI.Size.Static
    ) -> SizeFloat {
        return Size(
            width: Self.apply(available: available.width, behaviour: width),
            height: Self.apply(available: available.height, behaviour: height)
        )
    }
    
}
