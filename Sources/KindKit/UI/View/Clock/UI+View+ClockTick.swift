//
//  KindKit
//

import Foundation

extension UI.View {
    
    public struct ClockTick : Equatable {
        
        public let duration: TimeInterval
        public var elapsed: TimeInterval
        
    }
    
}

public extension UI.View.ClockTick {
    
    @inlinable
    var remainder: TimeInterval {
        return self.duration - self.elapsed
    }
    
}
