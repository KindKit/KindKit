//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@KindMonadic
public final class DateComponentsFormatter : IFormatter {
    
    public typealias InputType = Foundation.TimeInterval
    
    public let formatter = Foundation.DateComponentsFormatter()
    
    @KindMonadicProperty
    public var unitsStyle: Foundation.DateComponentsFormatter.UnitsStyle {
        set { self.formatter.unitsStyle = newValue }
        get { self.formatter.unitsStyle }
    }
    
    @KindMonadicProperty
    public var allowedUnits: NSCalendar.Unit {
        set { self.formatter.allowedUnits = newValue }
        get { self.formatter.allowedUnits }
    }
    
    @KindMonadicProperty
    public var zeroBehavior: Foundation.DateComponentsFormatter.ZeroFormattingBehavior {
        set { self.formatter.zeroFormattingBehavior = newValue }
        get { self.formatter.zeroFormattingBehavior }
    }
    
    @KindMonadicProperty
    public var calendar: Calendar {
        set { self.formatter.calendar = newValue }
        get { self.formatter.calendar ?? .current }
    }
    
    @KindMonadicProperty
    public var maximumUnitCount: Int {
        set { self.formatter.maximumUnitCount = newValue }
        get { self.formatter.maximumUnitCount }
    }
    
    @KindMonadicProperty
    public var collapsesLargestUnit: Bool {
        set { self.formatter.collapsesLargestUnit = newValue }
        get { self.formatter.collapsesLargestUnit }
    }
    
    @KindMonadicProperty
    public var includesApproximationPhrase: Bool {
        set { self.formatter.includesApproximationPhrase = newValue }
        get { self.formatter.includesApproximationPhrase }
    }
    
    public init() {
    }
    
    public func format(_ input: InputType) -> String {
        return self.formatter.string(from: input) ?? ""
    }
    
}

extension DateComponentsFormatter : Equatable {
    
    public static func == (lhs: DateComponentsFormatter, rhs: DateComponentsFormatter) -> Bool {
        return lhs === rhs
    }
    
}
