//
//  KindKit
//

import KindMath

extension ShouldEvent {

    public struct Pan {
        
        public let gesture: Gesture
        
    }
    
}

extension ShouldEvent {
    
    static func pan(gesture: Gesture) -> Self {
        return .pan(.init(gesture: gesture))
    }
    
}
