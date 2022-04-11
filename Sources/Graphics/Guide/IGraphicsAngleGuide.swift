//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsAngleGuide : AnyObject {
    
    func guide(_ value: AngleFloat) -> AngleFloat?

}
