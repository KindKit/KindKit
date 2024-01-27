//
//  KindKit
//

import KindMath

extension Event {

    public struct Rotation {
        
        public let state: Gesture.State
        public let location: Point
        public let angle: Angle
        
    }
    
}

extension Event {
    
    static func rotation(state: Gesture.State, location: Point, angle: Angle) -> Self {
        return .rotation(.init(state: state, location: location, angle: angle))
    }
    
}
