//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath
import KindKitView

public extension GraphicsGuide {

    class Angle : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var value: AngleFloat
        public var snap: AngleFloat
        
        public init(
            isEnabled: Bool = true,
            value: AngleFloat,
            snap: AngleFloat
        ) {
            self.isEnabled = isEnabled
            self.value = value
            self.snap = snap
        }

    }
    
}

extension GraphicsGuide.Angle : IGraphicsAngleGuide {
    
    public func guide(_ angle: AngleFloat) -> AngleFloat? {
        guard self.isEnabled == true else { return nil }
        let s = angle.radians / self.value.radians
        let p = self.value.radians * s.roundDown
        let n = self.value.radians * s.roundUp
        let pd = angle.radians - p
        let nd = n - angle.radians
        let md = min(pd, nd)
        if md < self.snap.radians {
            if pd < nd {
                return AngleFloat(radians: p)
            } else if nd < pd {
                return AngleFloat(radians: n)
            }
        }
        return nil
    }
    
}
