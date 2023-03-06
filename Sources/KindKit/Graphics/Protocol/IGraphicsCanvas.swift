//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IGraphicsCanvas : AnyObject {
    
    var appearedView: UI.View.Canvas? { get }
    
    func attach(view: UI.View.Canvas)
    func detach()
    
    func resize(_ size: Size)
    
    func draw(_ context: Graphics.Context, bounds: Rect)
    
    func shouldTapGesture(_ gesture: Graphics.Gesture) -> Bool
    func tapGesture(_ gesture: Graphics.Gesture, location: Point)
    
    func shouldLongTapGesture(_ gesture: Graphics.Gesture) -> Bool
    func longTapGesture(_ gesture: Graphics.Gesture, location: Point)
    
    func shouldPanGesture(_ gesture: Graphics.Gesture) -> Bool
    func beginPanGesture(_ gesture: Graphics.Gesture, location: Point)
    func changePanGesture(_ gesture: Graphics.Gesture, location: Point)
    func endPanGesture(_ gesture: Graphics.Gesture, location: Point)
    
    func shouldPinchGesture() -> Bool
    func beginPinchGesture(location: Point, scale: Double)
    func changePinchGesture(location: Point, scale: Double)
    func endPinchGesture(location: Point, scale: Double)
    
    func shouldRotationGesture() -> Bool
    func beginRotationGesture(location: Point, angle: Angle)
    func changeRotationGesture(location: Point, angle: Angle)
    func endRotationGesture(location: Point, angle: Angle)
    
}

public extension IGraphicsCanvas {
    
    func setNeedRedraw() {
        self.appearedView?.setNeedRedraw()
    }
    
}

#endif
