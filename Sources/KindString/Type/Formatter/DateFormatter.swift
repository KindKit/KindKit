//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@KindMonadic
public final class DateFormatter : IFormatter {
    
    public typealias InputType = Foundation.Date
    
    public let formatter = Foundation.DateFormatter()
    
    @KindMonadicProperty
    public var format: String {
        set { self.formatter.dateFormat = newValue }
        get { self.formatter.dateFormat }
    }
    
    @KindMonadicProperty
    public var dateStyle: Foundation.DateFormatter.Style {
        set { self.formatter.dateStyle = newValue }
        get { self.formatter.dateStyle }
    }
    
    @KindMonadicProperty
    public var timeStyle: Foundation.DateFormatter.Style {
        set { self.formatter.timeStyle = newValue }
        get { self.formatter.timeStyle }
    }
    
    @KindMonadicProperty
    public var calendar: Calendar {
        set { self.formatter.calendar = newValue }
        get { self.formatter.calendar }
    }
    
    @KindMonadicProperty
    public var locale: Locale {
        set { self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
    @KindMonadicProperty
    public var timeZone: TimeZone {
        set { self.formatter.timeZone = newValue }
        get { self.formatter.timeZone }
    }
    
    public init() {
    }
    
    public func format(_ input: InputType) -> String {
        return self.formatter.string(from: input)
    }
    
}

extension DateFormatter : Equatable {
    
    public static func == (lhs: DateFormatter, rhs: DateFormatter) -> Bool {
        return lhs === rhs
    }
    
}
