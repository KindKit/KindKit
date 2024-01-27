//
//  KindKit
//

import Foundation
import CoreMedia
import KindNumeric

public struct Time : Quantity {
    
    public typealias Value = Unit.Value
    
    public let value: Value
    public let unit: Unit
    
    public init(value: Value, unit: Unit) {
        self.value = value
        self.unit = unit
    }
    
    @inlinable
    public init(timeInterval: TimeInterval) {
        self.init(
            value: timeInterval,
            unit: .second
        )
    }
    
    @inlinable
    public init(dispatchTime: DispatchTime) {
        self.init(
            value: .init(dispatchTime.uptimeNanoseconds),
            unit: .nanosecond
        )
    }
    
    @inlinable
    public init(date: Date)  {
        self.init(
            value: .init(date.timeIntervalSince1970),
            unit: .second
        )
    }
    
    @inlinable
    public init(cmTime: CMTime)  {
        self.init(
            value: .init(cmTime.seconds),
            unit: .second
        )
    }
    
}

extension Time : Hashable {
}

extension Time : Equatable {
}

extension Time : Sendable {
}

public extension Time {
    
    @inlinable
    static var now: Self {
        return .init(date: Date())
    }
    
}

public extension Time {
    
    @inlinable
    var timeInterval: TimeInterval {
        return .init(self.value(to: .second))
    }
    
    @inlinable
    var dispatchTimeInterval: DispatchTimeInterval {
        return .milliseconds(.init(self.value(to: .millisecond)))
    }
    
    @inlinable
    var cmTime: CMTime {
        return .init(
            seconds: self.value(to: .second),
            preferredTimescale: .init(NSEC_PER_SEC)
        )
    }
    
}
