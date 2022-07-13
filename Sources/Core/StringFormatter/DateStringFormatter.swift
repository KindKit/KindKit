//
//  KindKitCore
//

import Foundation

public struct DateStringFormatter : IStringFormatter {
    
    public let formatter: DateFormatter
    
    public init(
        format: String,
        calendar: Calendar = Calendar.current,
        locale: Locale = Locale.current
    ) {
        self.formatter = DateFormatter()
        self.formatter.calendar = calendar
        self.formatter.locale = locale
        self.formatter.dateFormat = format
    }
    
    public func format(_ input: Date) -> String {
        return self.formatter.string(from: input)
    }
    
}
