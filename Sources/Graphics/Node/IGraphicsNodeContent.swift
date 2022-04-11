//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsNodeContent : AnyObject {
    
    func hitTest(_ node: GraphicsNode, global: PointFloat, local: PointFloat) -> Bool
    func preDraw(_ node: GraphicsNode, context: GraphicsContext, bounds: RectFloat)
    func postDraw(_ node: GraphicsNode, context: GraphicsContext, bounds: RectFloat)
    
}

extension IGraphicsNodeContent {
    
    public func hitTest(_ node: GraphicsNode, global: PointFloat, local: PointFloat) -> Bool {
        return false
    }
    
    public func preDraw(_ node: GraphicsNode, context: GraphicsContext, bounds: RectFloat) {
    }
    
    public func postDraw(_ node: GraphicsNode, context: GraphicsContext, bounds: RectFloat) {
    }
    
}
