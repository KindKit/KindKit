//
//  KindKit
//

import Foundation

public extension Calendar {
    
    @inlinable
    static func kk_make(
        locale: Locale = Locale.current,
        timeZone: TimeZone = TimeZone.current
    ) -> Calendar {
        var calendar = Calendar.current
        calendar.locale = locale
        calendar.timeZone = timeZone
        return calendar
    }
    
}
