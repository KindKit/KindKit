//
//  KindKitGraphics
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IGraphicsCanvas : AnyObject {
    
    var view: IGraphicsView? { get }
    
    func attach(view: IGraphicsView)
    func detach()
    
    func resize(_ size: SizeFloat)
    
    func draw(_ context: GraphicsContext, bounds: RectFloat)
    
    func shouldTapGesture(_ gesture: GraphicsCanvasGesture) -> Bool
    func tapGesture(_ gesture: GraphicsCanvasGesture, location: PointFloat)
    
    func shouldLongTapGesture(_ gesture: GraphicsCanvasGesture) -> Bool
    func longTapGesture(_ gesture: GraphicsCanvasGesture, location: PointFloat)
    
    func shouldPanGesture(_ gesture: GraphicsCanvasGesture) -> Bool
    func beginPanGesture(_ gesture: GraphicsCanvasGesture, location: PointFloat)
    func changePanGesture(_ gesture: GraphicsCanvasGesture, location: PointFloat)
    func endPanGesture(_ gesture: GraphicsCanvasGesture, location: PointFloat)
    
    func shouldPinchGesture() -> Bool
    func beginPinchGesture(location: PointFloat, scale: Float)
    func changePinchGesture(location: PointFloat, scale: Float)
    func endPinchGesture(location: PointFloat, scale: Float)
    
    func shouldRotationGesture() -> Bool
    func beginRotationGesture(location: PointFloat, angle: AngleFloat)
    func changeRotationGesture(location: PointFloat, angle: AngleFloat)
    func endRotationGesture(location: PointFloat, angle: AngleFloat)
    
}

public extension IGraphicsCanvas {
    
    func setNeedRedraw() {
        self.view?.setNeedRedraw()
    }
    
}
