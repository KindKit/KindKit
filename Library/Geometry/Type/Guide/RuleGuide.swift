//
//  KindKit
//

import KindNumeric
import KindMonadicMacro

@Monadic
public final class RuleGuide : Guide {
    
    public var isEnabled: Bool = true
    
    @MonadicField
    public var size: Distance
    
    @MonadicField
    public var snap: Distance
    
    public init(
        size: Distance,
        snap: Distance
    ) {
        self.size = size
        self.snap = snap
    }
    
    public func guide(_ value: Distance) -> Distance {
        guard self.isEnabled == true else { return value }
        let n = value.abs
        let b = (n / self.size).roundedNearest
        let g = b * self.size
        if n >= g - self.snap && n <= g + self.snap {
            if value < .zero {
                return -g
            } else {
                return g
            }
        }
        return value
    }
    
}
