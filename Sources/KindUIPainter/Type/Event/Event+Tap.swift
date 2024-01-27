//
//  KindKit
//

import KindMath

extension Event {

    public struct Tap {
        
        public let gesture: Gesture
        public let location: Point
        
    }
    
}

extension Event {
    
    static func tap(gesture: Gesture, location: Point) -> Self {
        return .tap(.init(gesture: gesture, location: location))
    }
    
    static func longTap(gesture: Gesture, location: Point) -> Self {
        return .longTap(.init(gesture: gesture, location: location))
    }
    
}
