//
//  KindKit
//

import Foundation

public protocol IGraphicsNodeContent : AnyObject {
    
    func hitTest(_ node: Graphics.Node, global: PointFloat, local: PointFloat) -> Bool
    func preDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: RectFloat)
    func postDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: RectFloat)
    
}

extension IGraphicsNodeContent {
    
    public func hitTest(_ node: Graphics.Node, global: PointFloat, local: PointFloat) -> Bool {
        return false
    }
    
    public func preDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: RectFloat) {
    }
    
    public func postDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: RectFloat) {
    }
    
}
