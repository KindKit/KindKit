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
    
    func kk_isEqual(calendar: Calendar, date: Date, component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: component)
    }

}
