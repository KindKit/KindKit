//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@Monadic
public final class DateFormatter : FormatterTrait {
    
    public typealias Input = Foundation.Date
    
    public let formatter = Foundation.DateFormatter()
    
    @MonadicField
    public var format: String {
        set { self.formatter.dateFormat = newValue }
        get { self.formatter.dateFormat }
    }
    
    @MonadicField
    public var dateStyle: Foundation.DateFormatter.Style {
        set { self.formatter.dateStyle = newValue }
        get { self.formatter.dateStyle }
    }
    
    @MonadicField
    public var timeStyle: Foundation.DateFormatter.Style {
        set { self.formatter.timeStyle = newValue }
        get { self.formatter.timeStyle }
    }
    
    @MonadicField
    public var calendar: Calendar {
        set { self.formatter.calendar = newValue }
        get { self.formatter.calendar }
    }
    
    @MonadicField
    public var locale: Locale {
        set { self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
    @MonadicField
    public var timeZone: TimeZone {
        set { self.formatter.timeZone = newValue }
        get { self.formatter.timeZone }
    }
    
    public init() {
    }
    
    public func format(_ input: Input) -> String {
        return self.formatter.string(from: input)
    }
    
}

extension DateFormatter : Equatable {
    
    public static func == (lhs: DateFormatter, rhs: DateFormatter) -> Bool {
        return lhs === rhs
    }
    
}
