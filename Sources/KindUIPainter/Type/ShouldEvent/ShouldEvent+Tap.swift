//
//  KindKit
//

import KindMath

extension ShouldEvent {

    public struct Tap {
        
        public let gesture: Gesture
        
    }
    
}

extension ShouldEvent {
    
    static func tap(gesture: Gesture) -> Self {
        return .tap(.init(gesture: gesture))
    }
    
    static func longTap(gesture: Gesture) -> Self {
        return .longTap(.init(gesture: gesture))
    }
    
}
