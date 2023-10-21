//
//  KindKit
//

import Foundation

extension Timer {

    public enum Interval : Equatable {
        
        case timeInterval(TimeInterval)
        case nanoseconds(Int)
        case microseconds(Int)
        case milliseconds(Int)
        case seconds(Int)
        case minutes(Int)
        case hours(Int)
        case days(Int)

    }
    
}

extension Timer.Interval {
    
    @inlinable
    var asDispatchTimeInterval: DispatchTimeInterval {
        switch self {
        case .timeInterval(let value): return .milliseconds(Int(value * 1000))
        case .nanoseconds(let value): return .nanoseconds(value)
        case .microseconds(let value): return .microseconds(value)
        case .milliseconds(let value): return .milliseconds(value)
        case .seconds(let value): return .seconds(value)
        case .minutes(let value): return .seconds(value * 60)
        case .hours(let value): return .seconds(value * 3600)
        case .days(let value): return .seconds(value * 86400)
        }
    }
    
}
