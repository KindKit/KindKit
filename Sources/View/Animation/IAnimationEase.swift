//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IAnimationEase {
    
    func perform(_ x: Float) -> Float
    
}

public extension IAnimationEase {
    
    func perform(_ x: PercentFloat) -> PercentFloat {
        return Percent(self.perform(x.value))
    }
    
}
