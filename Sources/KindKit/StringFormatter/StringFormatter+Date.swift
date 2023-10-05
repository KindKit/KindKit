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
        nonmutating set { self.formatter.dateFormat = newValue }
        get { self.formatter.dateFormat }
    }
    
    @inlinable
    var calendar: Calendar {
        nonmutating set { self.formatter.calendar = newValue }
        get { self.formatter.calendar }
    }
    
    @inlinable
    var locale: Locale {
        nonmutating set { self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
    @inlinable
    var timeZone: TimeZone {
        nonmutating set { self.formatter.timeZone = newValue }
        get { self.formatter.timeZone }
    }
    
}

public extension StringFormatter.Date {
    
    @inlinable
    @discardableResult
    func format(_ value: String) -> Self {
        self.format = value
        return self
    }
    
    @inlinable
    @discardableResult
    func calendar(_ value: Calendar) -> Self {
        self.calendar = value
        return self
    }
    
    @inlinable
    @discardableResult
    func locale(_ value: Locale) -> Self {
        self.locale = value
        return self
    }
    
    @inlinable
    @discardableResult
    func timeZone(_ value: TimeZone) -> Self {
        self.timeZone = value
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
