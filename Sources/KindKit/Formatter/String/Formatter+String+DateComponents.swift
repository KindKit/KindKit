//
//  KindKit
//

import Foundation

public extension Formatter.String {

    struct DateComponents : IFormatter, Equatable {
        
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

public extension Formatter.String.DateComponents {
    
    @inlinable
    var unitsStyle: DateComponentsFormatter.UnitsStyle {
        nonmutating set { self.formatter.unitsStyle = newValue }
        get { self.formatter.unitsStyle }
    }
    
    @inlinable
    var allowedUnits: NSCalendar.Unit {
        nonmutating set { self.formatter.allowedUnits = newValue }
        get { self.formatter.allowedUnits }
    }
    
    @inlinable
    var zeroBehavior: DateComponentsFormatter.ZeroFormattingBehavior {
        nonmutating set { self.formatter.zeroFormattingBehavior = newValue }
        get { self.formatter.zeroFormattingBehavior }
    }
    
    @inlinable
    var calendar: Calendar {
        nonmutating set { self.formatter.calendar = newValue }
        get { self.formatter.calendar ?? .current }
    }
    
    @inlinable
    var maximumUnitCount: Int {
        nonmutating set { self.formatter.maximumUnitCount = newValue }
        get { self.formatter.maximumUnitCount }
    }
    
    @inlinable
    var collapsesLargestUnit: Bool {
        nonmutating set { self.formatter.collapsesLargestUnit = newValue }
        get { self.formatter.collapsesLargestUnit }
    }
    
    @inlinable
    var includesApproximationPhrase: Bool {
        nonmutating set { self.formatter.includesApproximationPhrase = newValue }
        get { self.formatter.includesApproximationPhrase }
    }
    
}

public extension Formatter.String.DateComponents {
    
    @inlinable
    @discardableResult
    func unitsStyle(_ value: DateComponentsFormatter.UnitsStyle) -> Self {
        self.unitsStyle = value
        return self
    }
    
    @inlinable
    @discardableResult
    func allowedUnits(_ value: NSCalendar.Unit) -> Self {
        self.allowedUnits = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zeroBehavior(_ value: DateComponentsFormatter.ZeroFormattingBehavior) -> Self {
        self.zeroBehavior = value
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
    func maximumUnitCount(_ value: Int) -> Self {
        self.maximumUnitCount = value
        return self
    }
    
    @inlinable
    @discardableResult
    func collapsesLargestUnit(_ value: Bool) -> Self {
        self.collapsesLargestUnit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func includesApproximationPhrase(_ value: Bool) -> Self {
        self.includesApproximationPhrase = value
        return self
    }
    
}

public extension IFormatter where Self == Formatter.String.DateComponents {
    
    @inlinable
    static func dateComponents() -> Self {
        return .init()
    }
    
}

public extension TimeInterval {
    
    @inlinable
    func kk_format(dateComponents formatter: Formatter.String.DateComponents) -> String {
        return formatter.format(self)
    }
    
}
