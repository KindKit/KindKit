//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IGraphicsCanvas : AnyObject {
    
    var view: UI.View.Canvas? { get }
    
    func attach(view: UI.View.Canvas)
    func detach()
    
    func resize(_ size: SizeFloat)
    
    func draw(_ context: Graphics.Context, bounds: RectFloat)
    
    func shouldTapGesture(_ gesture: Graphics.Gesture) -> Bool
    func tapGesture(_ gesture: Graphics.Gesture, location: PointFloat)
    
    func shouldLongTapGesture(_ gesture: Graphics.Gesture) -> Bool
    func longTapGesture(_ gesture: Graphics.Gesture, location: PointFloat)
    
    func shouldPanGesture(_ gesture: Graphics.Gesture) -> Bool
    func beginPanGesture(_ gesture: Graphics.Gesture, location: PointFloat)
    func changePanGesture(_ gesture: Graphics.Gesture, location: PointFloat)
    func endPanGesture(_ gesture: Graphics.Gesture, location: PointFloat)
    
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

#endif
