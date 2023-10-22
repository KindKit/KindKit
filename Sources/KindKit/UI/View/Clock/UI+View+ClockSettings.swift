//
//  KindKit
//

import Foundation

extension UI.View {
    
    public struct ClockSettings : Equatable {
        
        public let interval: Timer.Interval
        public let iterations: Int
        public let tolerance: DispatchTimeInterval
        
        public init(
            interval: Timer.Interval,
            iterations: Int,
            tolerance: DispatchTimeInterval = .nanoseconds(0)
        ) {
            self.interval = interval
            self.iterations = iterations
            self.tolerance = tolerance
        }
        
    }
    
}

extension UI.View.ClockSettings {
    
    @inlinable
    var duration: TimeInterval {
        switch self.interval {
        case .timeInterval(let value): return value * TimeInterval(self.iterations)
        case .nanoseconds(let value): return TimeInterval(value * self.iterations) / 1_000_000_000
        case .microseconds(let value): return TimeInterval(value * self.iterations) / 1_000_000
        case .milliseconds(let value): return TimeInterval(value * self.iterations) / 1_000
        case .seconds(let value): return TimeInterval(value * self.iterations)
        case .minutes(let value): return TimeInterval(60 * value * self.iterations)
        case .hours(let value): return TimeInterval(3600 * value * self.iterations)
        case .days(let value): return TimeInterval(86400 * value * self.iterations)
        }
    }
    
}
