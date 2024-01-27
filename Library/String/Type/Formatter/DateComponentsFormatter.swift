//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@Monadic
public final class DateComponentsFormatter : FormatterTrait {
    
    public typealias Input = Foundation.TimeInterval
    
    public let formatter = Foundation.DateComponentsFormatter()
    
    @MonadicField
    public var unitsStyle: Foundation.DateComponentsFormatter.UnitsStyle {
        set { self.formatter.unitsStyle = newValue }
        get { self.formatter.unitsStyle }
    }
    
    @MonadicField
    public var allowedUnits: NSCalendar.Unit {
        set { self.formatter.allowedUnits = newValue }
        get { self.formatter.allowedUnits }
    }
    
    @MonadicField
    public var zeroBehavior: Foundation.DateComponentsFormatter.ZeroFormattingBehavior {
        set { self.formatter.zeroFormattingBehavior = newValue }
        get { self.formatter.zeroFormattingBehavior }
    }
    
    @MonadicField
    public var calendar: Calendar {
        set { self.formatter.calendar = newValue }
        get { self.formatter.calendar ?? .current }
    }
    
    @MonadicField
    public var maximumUnitCount: Int {
        set { self.formatter.maximumUnitCount = newValue }
        get { self.formatter.maximumUnitCount }
    }
    
    @MonadicField
    public var collapsesLargestUnit: Bool {
        set { self.formatter.collapsesLargestUnit = newValue }
        get { self.formatter.collapsesLargestUnit }
    }
    
    @MonadicField
    public var includesApproximationPhrase: Bool {
        set { self.formatter.includesApproximationPhrase = newValue }
        get { self.formatter.includesApproximationPhrase }
    }
    
    public init() {
    }
    
    public func format(_ input: Input) -> String {
        return self.formatter.string(from: input) ?? ""
    }
    
}

extension DateComponentsFormatter : Equatable {
    
    public static func == (lhs: DateComponentsFormatter, rhs: DateComponentsFormatter) -> Bool {
        return lhs === rhs
    }
    
}
