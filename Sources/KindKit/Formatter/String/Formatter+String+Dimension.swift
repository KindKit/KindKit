//
//  KindKit
//

import Foundation

public extension Formatter.String {

    struct Dimension< DimensionType : Foundation.Dimension > : IFormatter, Equatable {
        
        public let unit: DimensionType
        public let formatter: MeasurementFormatter
        
        public init(unit: DimensionType) {
            self.unit = unit
            self.formatter = .init()
            self.formatter.unitOptions = .providedUnit
        }
        
        public func format(_ input: Measurement< DimensionType >) -> String {
            let measurement: Measurement< DimensionType >
            if input.unit != self.unit {
                measurement = input.converted(to: self.unit)
            } else {
                measurement = input
            }
            return self.formatter.string(from: measurement)
        }
        
    }

}

public extension Formatter.String.Dimension {
    
    @inlinable
    var minIntegerDigits: Int {
        nonmutating set { self.formatter.numberFormatter.minimumIntegerDigits = newValue }
        get { self.formatter.numberFormatter.minimumIntegerDigits }
    }
    
    @inlinable
    var maxIntegerDigits: Int {
        nonmutating set { self.formatter.numberFormatter.maximumIntegerDigits = newValue }
        get { self.formatter.numberFormatter.maximumIntegerDigits }
    }
    
    @inlinable
    var zeroSymbol: String {
        nonmutating set { self.formatter.numberFormatter.zeroSymbol = newValue }
        get { self.formatter.numberFormatter.zeroSymbol ?? "" }
    }
    
    @inlinable
    var plusSign: String {
        nonmutating set { self.formatter.numberFormatter.plusSign = newValue }
        get { self.formatter.numberFormatter.plusSign }
    }
    
    @inlinable
    var minusSign: String {
        nonmutating set { self.formatter.numberFormatter.minusSign = newValue }
        get { self.formatter.numberFormatter.minusSign }
    }
    
    @inlinable
    var positivePrefix: String {
        nonmutating set { self.formatter.numberFormatter.positivePrefix = newValue }
        get { self.formatter.numberFormatter.positivePrefix }
    }
    
    @inlinable
    var positiveSuffix: String {
        nonmutating set { self.formatter.numberFormatter.positiveSuffix = newValue }
        get { self.formatter.numberFormatter.positiveSuffix }
    }
    
    @inlinable
    var negativePrefix: String {
        nonmutating set { self.formatter.numberFormatter.negativePrefix = newValue }
        get { self.formatter.numberFormatter.negativePrefix }
    }
    
    @inlinable
    var negativeSuffix: String {
        nonmutating set { self.formatter.numberFormatter.negativeSuffix = newValue }
        get { self.formatter.numberFormatter.negativeSuffix }
    }
    
    @inlinable
    var usesGroupingSeparator: Bool {
        nonmutating set { self.formatter.numberFormatter.usesGroupingSeparator = newValue }
        get { self.formatter.numberFormatter.usesGroupingSeparator }
    }
    
    @inlinable
    var groupingSeparator: String {
        nonmutating set { self.formatter.numberFormatter.groupingSeparator = newValue }
        get { self.formatter.numberFormatter.groupingSeparator }
    }
    
    @inlinable
    var groupingSize: Int {
        nonmutating set { self.formatter.numberFormatter.groupingSize = newValue }
        get { self.formatter.numberFormatter.groupingSize }
    }
    
    @inlinable
    var secondaryGroupingSize: Int {
        nonmutating set { self.formatter.numberFormatter.secondaryGroupingSize = newValue }
        get { self.formatter.numberFormatter.secondaryGroupingSize }
    }
    
    @inlinable
    var locale: Locale {
        nonmutating set { self.formatter.numberFormatter.locale = newValue }
        get { self.formatter.numberFormatter.locale }
    }
    
}

public extension Formatter.String.Dimension {
    
    @inlinable
    @discardableResult
    func minIntegerDigits(_ value: Int) -> Self {
        self.minIntegerDigits = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maxIntegerDigits(_ value: Int) -> Self {
        self.maxIntegerDigits = value
        return self
    }
    
    @inlinable
    @discardableResult
    func zeroSymbol(_ value: String) -> Self {
        self.zeroSymbol = value
        return self
    }
    
    @inlinable
    @discardableResult
    func plusSign(_ value: String) -> Self {
        self.plusSign = value
        return self
    }
    
    @inlinable
    @discardableResult
    func minusSign(_ value: String) -> Self {
        self.minusSign = value
        return self
    }
    
    @inlinable
    @discardableResult
    func positivePrefix(_ value: String) -> Self {
        self.positivePrefix = value
        return self
    }
    
    @inlinable
    @discardableResult
    func positiveSuffix(_ value: String) -> Self {
        self.positiveSuffix = value
        return self
    }
    
    @inlinable
    @discardableResult
    func negativePrefix(_ value: String) -> Self {
        self.negativePrefix = value
        return self
    }
    
    @inlinable
    @discardableResult
    func negativeSuffix(_ value: String) -> Self {
        self.negativeSuffix = value
        return self
    }
    
    @inlinable
    @discardableResult
    func usesGroupingSeparator(_ value: Bool) -> Self {
        self.usesGroupingSeparator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func groupingSeparator(_ value: String) -> Self {
        self.groupingSeparator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func groupingSize(_ value: Int) -> Self {
        self.groupingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func secondaryGroupingSize(_ value: Int) -> Self {
        self.secondaryGroupingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func locale(_ value: Locale) -> Self {
        self.locale = value
        return self
    }
    
}

public extension IFormatter where Self == Formatter.String.Dimension< UnitLength > {
    
    static func length(_ unit: UnitLength) -> Self {
        return .init(unit: unit)
    }
    
}
