//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@Monadic
public final class DimensionFormatter< Dimension : Foundation.Dimension > : FormatterTrait {
    
    public let unit: Dimension
    public let formatter: MeasurementFormatter
    
    @MonadicField
    public var minIntegerDigits: Int {
        set { self.formatter.numberFormatter.minimumIntegerDigits = newValue }
        get { self.formatter.numberFormatter.minimumIntegerDigits }
    }
    
    @MonadicField
    public var maxIntegerDigits: Int {
        set { self.formatter.numberFormatter.maximumIntegerDigits = newValue }
        get { self.formatter.numberFormatter.maximumIntegerDigits }
    }
    
    @MonadicField
    public var zeroSymbol: String {
        set { self.formatter.numberFormatter.zeroSymbol = newValue }
        get { self.formatter.numberFormatter.zeroSymbol ?? "" }
    }
    
    @MonadicField
    public var plusSign: String {
        set { self.formatter.numberFormatter.plusSign = newValue }
        get { self.formatter.numberFormatter.plusSign }
    }
    
    @MonadicField
    public var minusSign: String {
        set { self.formatter.numberFormatter.minusSign = newValue }
        get { self.formatter.numberFormatter.minusSign }
    }
    
    @MonadicField
    public var positivePrefix: String {
        set { self.formatter.numberFormatter.positivePrefix = newValue }
        get { self.formatter.numberFormatter.positivePrefix }
    }
    
    @MonadicField
    public var positiveSuffix: String {
        set { self.formatter.numberFormatter.positiveSuffix = newValue }
        get { self.formatter.numberFormatter.positiveSuffix }
    }
    
    @MonadicField
    public var negativePrefix: String {
        set { self.formatter.numberFormatter.negativePrefix = newValue }
        get { self.formatter.numberFormatter.negativePrefix }
    }
    
    @MonadicField
    public var negativeSuffix: String {
        set { self.formatter.numberFormatter.negativeSuffix = newValue }
        get { self.formatter.numberFormatter.negativeSuffix }
    }
    
    @MonadicField
    public var usesGroupingSeparator: Bool {
        set { self.formatter.numberFormatter.usesGroupingSeparator = newValue }
        get { self.formatter.numberFormatter.usesGroupingSeparator }
    }
    
    @MonadicField
    public var groupingSeparator: String {
        set { self.formatter.numberFormatter.groupingSeparator = newValue }
        get { self.formatter.numberFormatter.groupingSeparator }
    }
    
    @MonadicField
    public var groupingSize: Int {
        set { self.formatter.numberFormatter.groupingSize = newValue }
        get { self.formatter.numberFormatter.groupingSize }
    }
    
    @MonadicField
    public var secondaryGroupingSize: Int {
        set { self.formatter.numberFormatter.secondaryGroupingSize = newValue }
        get { self.formatter.numberFormatter.secondaryGroupingSize }
    }
    
    @MonadicField
    public var locale: Locale {
        set { self.formatter.numberFormatter.locale = newValue }
        get { self.formatter.numberFormatter.locale }
    }
    
    public init(unit: Dimension) {
        self.unit = unit
        self.formatter = .init()
        self.formatter.unitOptions = .providedUnit
    }
    
    public func format(_ input: Measurement< Dimension >) -> String {
        let measurement: Measurement< Dimension >
        if input.unit != self.unit {
            measurement = input.converted(to: self.unit)
        } else {
            measurement = input
        }
        return self.formatter.string(from: measurement)
    }
    
}

extension DimensionFormatter : Equatable {
    
    public static func == (lhs: DimensionFormatter, rhs: DimensionFormatter) -> Bool {
        return lhs === rhs
    }
    
}
