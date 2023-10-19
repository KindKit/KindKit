//
//  KindKit
//

import Foundation

extension UI.View {
    
    public struct TimerSettings : Equatable {
        
        public let interval: TimeInterval
        public let duration: TimeInterval
        public let elapsed: TimeInterval
        
        init(
            interval: TimeInterval,
            duration: TimeInterval,
            elapsed: TimeInterval
        ) {
            self.interval = interval
            self.duration = duration
            self.elapsed = elapsed
        }
        
        public init(
            interval: TimeInterval,
            duration: TimeInterval
        ) {
            self.interval = interval
            self.duration = duration
            self.elapsed = 0
        }
        
    }
    
}

extension UI.View.TimerSettings {
    
    var `repeat`: UInt {
        if self.duration.isInfinite == true {
            return .max
        }
        return UInt(self.duration / self.interval) + 1
    }
    
    var isDone: Bool {
        return self.elapsed >~ self.duration
    }
    
    func next(_ time: TimeInterval) -> Self {
        return .init(
            interval: self.interval,
            duration: self.duration,
            elapsed: self.elapsed + time
        )
    }
    
}
