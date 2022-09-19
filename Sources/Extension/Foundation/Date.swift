//
//  KindKit
//

import Foundation

public extension Date {
    
    init?(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone = TimeZone.current
    ) {
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
        guard let date = components.date else { return nil }
        self = date
    }
    
    init?(
        year: Int,
        month: Int,
        day: Int,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone = TimeZone.current
    ) {
        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: year,
            month: month,
            day: day
        )
        guard let date = components.date else { return nil }
        self = date
    }
    
    init?(
        hour: Int,
        minute: Int,
        second: Int,
        calendar: Calendar = Calendar.current,
        timeZone: TimeZone = TimeZone.current
    ) {
        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            hour: hour,
            minute: minute,
            second: second
        )
        guard let date = components.date else { return nil }
        self = date
    }
    
    func isEqual(calendar: Calendar, date: Date, component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: component)
    }

}
