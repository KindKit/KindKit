//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct DateComponents : IStringFormatter {
        
        public typealias InputType = TimeInterval
        
        public let formatter: DateComponentsFormatter
        
        public init(
            unitsStyle: DateComponentsFormatter.UnitsStyle,
            allowedUnits: NSCalendar.Unit,
            zeroBehavior: DateComponentsFormatter.ZeroFormattingBehavior = .default,
            calendar: Calendar = Calendar.current,
            maximumUnitCount: Int = 0,
            collapsesLargestUnit: Bool = false,
            includesApproximationPhrase: Bool = false
        ) {
            self.formatter = DateComponentsFormatter()
            self.formatter.calendar = calendar
            self.formatter.unitsStyle = unitsStyle
            self.formatter.allowedUnits = allowedUnits
            self.formatter.zeroFormattingBehavior = zeroBehavior
            self.formatter.maximumUnitCount = maximumUnitCount
            self.formatter.collapsesLargestUnit = collapsesLargestUnit
            self.formatter.includesApproximationPhrase = includesApproximationPhrase
        }
        
        public func format(_ input: InputType) -> String {
            return self.formatter.string(from: input) ?? ""
        }
        
    }

}
