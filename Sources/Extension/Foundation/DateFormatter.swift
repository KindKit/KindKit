//
//  File.swift
//  
//
//  Created by Alexander Trifonov on 19.09.2022.
//

import Foundation

public extension DateFormatter {
    
    convenience init(
        format: String,
        calendar: Calendar = Calendar.current,
        locale: Locale = Locale.current,
        timeZone: TimeZone = TimeZone.current
    ) {
        self.init()
        self.calendar = calendar
        self.locale = locale
        self.dateFormat = format
        self.timeZone = timeZone
    }
    
}
