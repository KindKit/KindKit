//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct Date : IStringFormatter, Equatable {
        
        public typealias InputType = Foundation.Date
        
        public let formatter: DateFormatter
        
        public init() {
            self.formatter = DateFormatter()
        }
        
        public func format(_ input: InputType) -> String {
            return self.formatter.string(from: input)
        }
        
    }

}

public extension StringFormatter.Date {
    
    @inlinable
    var format: String {
        return self.formatter.dateFormat
    }
    
    @inlinable
    var calendar: Calendar {
        return self.formatter.calendar
    }
    
    @inlinable
    var locale: Locale {
        return self.formatter.locale
    }
    
    @inlinable
    var timeZone: TimeZone {
        return self.formatter.timeZone
    }
    
}

public extension StringFormatter.Date {
    
    @inlinable
    func format(_ value: String) -> Self {
        self.formatter.dateFormat = value
        return self
    }
    
    @inlinable
    func calendar(_ value: Calendar) -> Self {
        self.formatter.calendar = value
        return self
    }
    
    @inlinable
    func locale(_ value: Locale) -> Self {
        self.formatter.locale = value
        return self
    }
    
    @inlinable
    func timeZone(_ value: TimeZone) -> Self {
        self.formatter.timeZone = value
        return self
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Date {
    
    static func date() -> Self {
        return .init()
    }
    
}

public extension Date {
    
    @inlinable
    func kk_format(date formatter: StringFormatter.Date) -> String {
        return formatter.format(self)
    }
    
}
