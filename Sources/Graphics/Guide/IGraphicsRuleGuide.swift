//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsRuleGuide : AnyObject {
    
    func guide(_ value: Float) -> Float?

}
