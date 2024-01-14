//
//  KindKit
//

import KindMath

extension CanvasView.Event {

    public struct Pan {
        
        public let gesture: CanvasView.Gesture
        public let state: CanvasView.Gesture.State
        public let location: Point
        
    }
    
}
