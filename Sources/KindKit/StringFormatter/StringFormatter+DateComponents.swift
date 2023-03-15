//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct DateComponents : IStringFormatter {
        
        public typealias InputType = TimeInterval
        
        public let formatter: DateComponentsFormatter
        
        public init() {
            self.formatter = DateComponentsFormatter()
        }
        
        public func format(_ input: InputType) -> String {
            return self.formatter.string(from: input) ?? ""
        }
        
    }

}

public extension StringFormatter.DateComponents {
    
    @inlinable
    func unitsStyle(_ value: DateComponentsFormatter.UnitsStyle) -> Self {
        self.formatter.unitsStyle = value
        return self
    }
    
    @inlinable
    func allowedUnits(_ value: NSCalendar.Unit) -> Self {
        self.formatter.allowedUnits = value
        return self
    }
    
    @inlinable
    func zeroBehavior(_ value: DateComponentsFormatter.ZeroFormattingBehavior) -> Self {
        self.formatter.zeroFormattingBehavior = value
        return self
    }
    
    @inlinable
    func calendar(_ value: Calendar) -> Self {
        self.formatter.calendar = value
        return self
    }
    
    @inlinable
    func maximumUnitCount(_ value: Int) -> Self {
        self.formatter.maximumUnitCount = value
        return self
    }
    
    @inlinable
    func collapsesLargestUnit(_ value: Bool) -> Self {
        self.formatter.collapsesLargestUnit = value
        return self
    }
    
    @inlinable
    func includesApproximationPhrase(_ value: Bool) -> Self {
        self.formatter.includesApproximationPhrase = value
        return self
    }
    
}

public extension IStringFormatter where Self == StringFormatter.DateComponents {
    
    static func dateComponents() -> Self {
        return .init()
    }
    
}
