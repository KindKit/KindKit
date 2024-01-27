//
//  KindKit
//

import KindMath

extension Event {

    public struct Pinch {
        
        public let state: Gesture.State
        public let location: Point
        public let scale: Double
        
    }
    
}

extension Event {
    
    static func pinch(state: Gesture.State, location: Point, scale: Double) -> Self {
        return .pinch(.init(state: state, location: location, scale: scale))
    }
    
}
