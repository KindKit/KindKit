//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsRuleGuide : IGraphicsGuide {
    
    func guide(_ value: Float) -> Float?

}
