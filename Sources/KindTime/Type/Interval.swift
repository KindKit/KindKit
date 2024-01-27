//
//  KindKit
//

import Foundation

public struct Interval< UnitType : IUnit > {
    
    public var value: Double
    
    public init< InputType : BinaryInteger >(_ value: InputType) {
        self.value = .init(value)
    }
    
    public init< InputType : BinaryFloatingPoint >(_ value: InputType) {
        self.value = .init(value)
    }
    
    public init(timeInterval: TimeInterval) {
        self.value = .init(timeInterval / UnitType.timeInterval)
    }
    
    public init< OtherUnitType : IUnit >(_ other: Interval< OtherUnitType >) {
        self.value = other.value * OtherUnitType.ratio(to: UnitType.self)
    }
    
    public init(dispatchTime: DispatchTime) {
        self.value = TimeInterval(dispatchTime.uptimeNanoseconds / 1_000_000_000) / UnitType.timeInterval
    }
    
    public init(_ date: Date)  {
        self.init(timeInterval: date.timeIntervalSince1970)
    }
    
}

public extension Interval {
    
    @inlinable
    static var zero: Self {
        return .init(0)
    }
    
    @inlinable
    static var one: Self {
        return .init(1)
    }
    
    @inlinable
    static var now: Self {
        return .init(timeInterval: Date().timeIntervalSince1970)
    }
    
}

public extension Interval {
    
    func delta(from: Self) -> Self {
        return from - self
    }
    
    func delta< OtherUnitType : IUnit >(from: Interval< OtherUnitType >) -> Self {
        return from.convert(to: UnitType.self) - self
    }
    
    func delta(to: Self) -> Self {
        return self - to
    }
    
    func delta< OtherUnitType : IUnit >(to: Interval< OtherUnitType >) -> Self {
        return self - to.convert(to: UnitType.self)
    }
    
}

extension Interval : IInterval {
    
    @inlinable
    public var timeInterval: TimeInterval {
        return self.value * UnitType.timeInterval
    }
    
    @inlinable
    public func convert< OtherUnitType : IUnit >(to type: OtherUnitType.Type) -> Interval< OtherUnitType > {
        return .init(self.value * UnitType.ratio(to: type))
    }
    
}

extension Interval : Equatable {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
    
    @inlinable
    public static func == < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Bool {
        return lhs == rhs.convert(to: UnitType.self)
    }
    
    @inlinable
    public static func != < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Bool {
        return lhs != rhs.convert(to: UnitType.self)
    }
    
}

extension Interval : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.timeInterval.hashValue)
    }
    
}

extension Interval {
    
    @inlinable
    public prefix static func - (lhs: Self) -> Self {
        return .init(-lhs.value)
    }

}

extension Interval {
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value + rhs.value)
    }
    
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    public static func + < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Self {
        return .init(timeInterval: lhs.timeInterval + rhs.timeInterval)
    }
    
    @inlinable
    public static func += < OtherUnitType : IUnit >(lhs: inout Self, rhs: Interval< OtherUnitType >) {
        lhs = lhs + rhs
    }

}

extension Interval {
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value - rhs.value)
    }
    
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    public static func - < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Self {
        return .init(timeInterval: lhs.timeInterval - rhs.timeInterval)
    }
    
    @inlinable
    public static func -= < OtherUnitType : IUnit >(lhs: inout Self, rhs: Interval< OtherUnitType >) {
        lhs = lhs - rhs
    }

}

extension Interval {
    
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value * rhs.value)
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    public static func * < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Self {
        return .init(timeInterval: lhs.timeInterval * rhs.timeInterval)
    }
    
    @inlinable
    public static func *= < OtherUnitType : IUnit >(lhs: inout Self, rhs: Interval< OtherUnitType >) {
        lhs = lhs * rhs
    }

}

extension Interval {
    
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value / rhs.value)
    }
    
    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    public static func / < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Self {
        return .init(timeInterval: lhs.timeInterval / rhs.timeInterval)
    }
    
    @inlinable
    public static func /= < OtherUnitType : IUnit >(lhs: inout Self, rhs: Interval< OtherUnitType >) {
        lhs = lhs / rhs
    }
    
}

extension Interval {
    
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
    
    @inlinable
    public static func < < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Bool {
        return lhs < rhs.convert(to: UnitType.self)
    }
    
}

extension Interval {
    
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.value <= rhs.value
    }
    
    @inlinable
    public static func <= < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Bool {
        return lhs <= rhs.convert(to: UnitType.self)
    }
    
}

extension Interval {
    
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.value >= rhs.value
    }
    
    @inlinable
    public static func > < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Bool {
        return lhs > rhs.convert(to: UnitType.self)
    }
    
}

extension Interval {
    
    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.value >= rhs.value
    }
    
    @inlinable
    public static func >= < OtherUnitType : IUnit >(lhs: Self, rhs: Interval< OtherUnitType >) -> Bool {
        return lhs >= rhs.convert(to: UnitType.self)
    }
    
}
