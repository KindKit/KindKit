//
//  KindKitGraphics
//

import Foundation
import KindKitView

public enum GraphicsFill : Equatable {
    case color(_ color: Color)
    case pattern(_ pattern: GraphicsPattern)
}
