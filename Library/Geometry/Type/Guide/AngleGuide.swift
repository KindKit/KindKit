//
//  KindKit
//

import KindNumeric
import KindMonadicMacro

@Monadic
public final class AngleGuide : Guide {
    
    public var isEnabled: Bool = true
    
    @MonadicField
    public var angle: Radian
    
    @MonadicField
    public var snap: Radian
    
    public init(
        angle: Radian,
        snap: Radian
    ) {
        self.angle = angle
        self.snap = snap
    }
    
    public func guide(_ input: Radian) -> Radian {
        guard self.isEnabled == true else { return input }
        let s = input / self.angle
        let p = self.angle * s.roundedDown
        let n = self.angle * s.roundedUp
        let pd = input - p
        let nd = n - input
        let md = pd.min(nd)
        if md < self.snap {
            if pd < nd {
                return p
            } else if nd < pd {
                return n
            }
        }
        return input
    }

}
