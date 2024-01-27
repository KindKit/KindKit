//
//  KindKit
//

import KindMath

extension Event {

    public struct Pan {
        
        public let gesture: Gesture
        public let state: Gesture.State
        public let location: Point
        
    }
    
}

extension Event {
    
    static func pan(gesture: Gesture, state: Gesture.State, location: Point) -> Self {
        return .pan(.init(gesture: gesture, state: state, location: location))
    }
    
}
