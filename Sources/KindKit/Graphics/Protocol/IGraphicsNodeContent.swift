//
//  KindKit
//

import Foundation

public protocol IGraphicsNodeContent : AnyObject {
    
    func hitTest(_ node: Graphics.Node, global: Point, local: Point) -> Bool
    func preDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: Rect)
    func postDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: Rect)
    
}

extension IGraphicsNodeContent {
    
    public func hitTest(_ node: Graphics.Node, global: Point, local: Point) -> Bool {
        return false
    }
    
    public func preDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: Rect) {
    }
    
    public func postDraw(_ node: Graphics.Node, context: Graphics.Context, bounds: Rect) {
    }
    
}
