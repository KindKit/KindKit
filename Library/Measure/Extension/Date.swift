//
//  KindKit
//

import Foundation

public extension Date {
    
    @inlinable
    func adding(_ time: Time) -> Date {
        return self.addingTimeInterval(time.timeInterval)
    }
    
    @inlinable
    mutating func add(_ time: Time) {
        self.addTimeInterval(time.timeInterval)
    }
    
    @inlinable
    static func + (lhs: Date, rhs: Time) -> Date {
        return lhs.adding(rhs)
    }
    
    @inlinable
    static func += (lhs: inout Date, rhs: Time) {
        lhs = lhs + rhs
    }
    
    @inlinable
    static func - (lhs: Date, rhs: Time) -> Date {
        return lhs.adding(-rhs)
    }
    
    @inlinable
    static func -= (lhs: inout Date, rhs: Time) {
        lhs = lhs - rhs
    }
    
}
