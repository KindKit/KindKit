//
//  KindKit
//

import Foundation

public extension Date {
    
    @inlinable
    func adding< UnitType : IUnit >(interval: Interval< UnitType >) -> Date {
        return self.addingTimeInterval(interval.timeInterval)
    }
    
    @inlinable
    mutating func add< UnitType : IUnit >(interval: Interval< UnitType >) {
        self.addTimeInterval(interval.timeInterval)
    }
    
    @inlinable
    static func + < UnitType : IUnit >(lhs: Date, rhs: Interval< UnitType >) -> Date {
        return lhs.adding(interval: rhs)
    }
    
    @inlinable
    static func += < UnitType : IUnit >(lhs: inout Date, rhs: Interval< UnitType >) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - < UnitType : IUnit >(lhs: Date, rhs: Interval< UnitType >) -> Date {
        return lhs.adding(interval: -rhs)
    }
    
    @inlinable
    static func -= < UnitType : IUnit >(lhs: inout Date, rhs: Interval< UnitType >) {
        lhs = lhs - rhs
    }
    
}
