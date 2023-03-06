//
//  KindKit
//

import Foundation

public extension Graphics.Guide {

    final class Angle : IGraphicsGuide {
        
        public var isEnabled: Bool
        public var value: KindKit.Angle
        public var snap: KindKit.Angle
        
        public init(
            isEnabled: Bool = true,
            value: KindKit.Angle,
            snap: KindKit.Angle
        ) {
            self.isEnabled = isEnabled
            self.value = value
            self.snap = snap
        }

    }
    
}

extension Graphics.Guide.Angle : IGraphicsAngleGuide {
    
    public func guide(_ angle: KindKit.Angle) -> KindKit.Angle? {
        guard self.isEnabled == true else { return nil }
        let s = angle.radians / self.value.radians
        let p = self.value.radians * s.roundDown
        let n = self.value.radians * s.roundUp
        let pd = angle.radians - p
        let nd = n - angle.radians
        let md = min(pd, nd)
        if md < self.snap.radians {
            if pd < nd {
                return .init(radians: p)
            } else if nd < pd {
                return .init(radians: n)
            }
        }
        return nil
    }
    
}
