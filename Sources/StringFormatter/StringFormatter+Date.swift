//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct Date : IStringFormatter {
        
        public typealias InputType = Foundation.Date
        
        public let formatter: DateFormatter
        
        public init(
            format: String,
            calendar: Calendar = Calendar.current,
            locale: Locale = Locale.current,
            timeZone: TimeZone = TimeZone.current
        ) {
            self.formatter = DateFormatter(
                format: format,
                calendar: calendar,
                locale: locale,
                timeZone: timeZone
            )
        }
        
        public func format(_ input: InputType) -> String {
            return self.formatter.string(from: input)
        }
        
    }

}
