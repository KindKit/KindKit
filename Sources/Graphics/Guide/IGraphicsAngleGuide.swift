//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsAngleGuide : IGraphicsGuide {
    
    func guide(_ value: AngleFloat) -> AngleFloat?

}
