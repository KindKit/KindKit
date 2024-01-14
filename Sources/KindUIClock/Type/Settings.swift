//
//  KindKit
//

import KindTimer

public struct Settings : Equatable {
    
    public let interval: KindTimer.Interval
    public let iterations: Int
    public let tolerance: DispatchTimeInterval
    
    public init(
        interval: KindTimer.Interval,
        iterations: Int,
        tolerance: DispatchTimeInterval = .nanoseconds(0)
    ) {
        self.interval = interval
        self.iterations = iterations
        self.tolerance = tolerance
    }
    
}

extension Settings {
    
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
