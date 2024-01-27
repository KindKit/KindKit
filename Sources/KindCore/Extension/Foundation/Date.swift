//
//  KindKit
//

import Foundation

public extension Date {
    
    @inlinable
    static func kk_make(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone = TimeZone.current
    ) -> Self? {
        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        return components.date
    }
    
    @inlinable
    static func kk_make(
        year: Int,
        month: Int,
        day: Int,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone = TimeZone.current
    ) -> Self? {
        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: year,
            month: month,
            day: day
        )
        return components.date
    }
    
    @inlinable
    static func kk_make(
        hour: Int,
        minute: Int,
        second: Int,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone = TimeZone.current
    ) -> Self? {
        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            hour: hour,
            minute: minute,
            second: second
        )
        return components.date
    }
    
    @inlinable
    func kk_isEqual(calendar: Calendar, date: Date, component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
}

public extension Date {
    
    @inlinable
    static func kk_date(unixTime: Int) -> Self {
        return .init(timeIntervalSince1970: .init(unixTime))
    }
    
    @inlinable
    var kk_unixTime: Int {
        return Int(self.timeIntervalSince1970)
    }
    
}

public extension Date {
    
    static let kk_julianDayOfZeroUnixTime: Double = 2440587.5
    static let kk_julianSecondsPerDay: Double = 86400
    
    @inlinable
    static func kk_date(julianDays: Double) -> Self {
        return .init(timeIntervalSince1970: (julianDays - Self.kk_julianDayOfZeroUnixTime) * Self.kk_julianSecondsPerDay)
    }
    
    @inlinable
    var kk_julianDays: Double {
        return Self.kk_julianDayOfZeroUnixTime + self.timeIntervalSince1970 / Self.kk_julianSecondsPerDay
    }

}
