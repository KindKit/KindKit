//
//  KindKit
//

import Foundation

public extension DateFormatter {
    
    @inlinable
    static func kk_make(
        format: String,
        calendar: Calendar = Calendar.current,
        locale: Locale = Locale.current,
        timeZone: TimeZone = TimeZone.current
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter
    }
    
}
