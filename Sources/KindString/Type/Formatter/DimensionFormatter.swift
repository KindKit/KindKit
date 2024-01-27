//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@KindMonadic
public final class DimensionFormatter< DimensionType : Foundation.Dimension > : IFormatter {
    
    public let unit: DimensionType
    public let formatter: MeasurementFormatter
    
    @KindMonadicProperty
    public var minIntegerDigits: Int {
        set { self.formatter.numberFormatter.minimumIntegerDigits = newValue }
        get { self.formatter.numberFormatter.minimumIntegerDigits }
    }
    
    @KindMonadicProperty
    public var maxIntegerDigits: Int {
        set { self.formatter.numberFormatter.maximumIntegerDigits = newValue }
        get { self.formatter.numberFormatter.maximumIntegerDigits }
    }
    
    @KindMonadicProperty
    public var zeroSymbol: String {
        set { self.formatter.numberFormatter.zeroSymbol = newValue }
        get { self.formatter.numberFormatter.zeroSymbol ?? "" }
    }
    
    @KindMonadicProperty
    public var plusSign: String {
        set { self.formatter.numberFormatter.plusSign = newValue }
        get { self.formatter.numberFormatter.plusSign }
    }
    
    @KindMonadicProperty
    public var minusSign: String {
        set { self.formatter.numberFormatter.minusSign = newValue }
        get { self.formatter.numberFormatter.minusSign }
    }
    
    @KindMonadicProperty
    public var positivePrefix: String {
        set { self.formatter.numberFormatter.positivePrefix = newValue }
        get { self.formatter.numberFormatter.positivePrefix }
    }
    
    @KindMonadicProperty
    public var positiveSuffix: String {
        set { self.formatter.numberFormatter.positiveSuffix = newValue }
        get { self.formatter.numberFormatter.positiveSuffix }
    }
    
    @KindMonadicProperty
    public var negativePrefix: String {
        set { self.formatter.numberFormatter.negativePrefix = newValue }
        get { self.formatter.numberFormatter.negativePrefix }
    }
    
    @KindMonadicProperty
    public var negativeSuffix: String {
        set { self.formatter.numberFormatter.negativeSuffix = newValue }
        get { self.formatter.numberFormatter.negativeSuffix }
    }
    
    @KindMonadicProperty
    public var usesGroupingSeparator: Bool {
        set { self.formatter.numberFormatter.usesGroupingSeparator = newValue }
        get { self.formatter.numberFormatter.usesGroupingSeparator }
    }
    
    @KindMonadicProperty
    public var groupingSeparator: String {
        set { self.formatter.numberFormatter.groupingSeparator = newValue }
        get { self.formatter.numberFormatter.groupingSeparator }
    }
    
    @KindMonadicProperty
    public var groupingSize: Int {
        set { self.formatter.numberFormatter.groupingSize = newValue }
        get { self.formatter.numberFormatter.groupingSize }
    }
    
    @KindMonadicProperty
    public var secondaryGroupingSize: Int {
        set { self.formatter.numberFormatter.secondaryGroupingSize = newValue }
        get { self.formatter.numberFormatter.secondaryGroupingSize }
    }
    
    @KindMonadicProperty
    public var locale: Locale {
        set { self.formatter.numberFormatter.locale = newValue }
        get { self.formatter.numberFormatter.locale }
    }
    
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

extension DimensionFormatter : Equatable {
    
    public static func == (lhs: DimensionFormatter, rhs: DimensionFormatter) -> Bool {
        return lhs === rhs
    }
    
}
