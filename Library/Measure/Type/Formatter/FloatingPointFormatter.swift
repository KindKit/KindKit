//
//  KindKit
//

import Foundation
import KindCore
import KindLocalize
import KindString
import KindMonadicMacro

@Monadic
public final class FloatingPointFormatter< Quantity : KindMeasure.Quantity > : FormatterTrait where Quantity.Value : BinaryFloatingPoint {
    
    @MonadicField
    public var unit: Quantity.Unit
    
    @MonadicField
    public var finder: (any KindLocalize.Finder)? {
        set { self._unitFormatter.finder = newValue }
        get { self._unitFormatter.finder }
    }
    
    @MonadicField
    public var width: Width {
        set { self._unitFormatter.width = newValue }
        get { self._unitFormatter.width }
    }
    
    @MonadicField
    public var minIntegerDigits: Int {
        set { self._valueFormatter.minIntegerDigits = newValue }
        get { self._valueFormatter.minIntegerDigits }
    }
    
    @MonadicField
    public var maxIntegerDigits: Int {
        set { self._valueFormatter.maxIntegerDigits = newValue }
        get { self._valueFormatter.maxIntegerDigits }
    }
    
    @MonadicField
    public var minFractionDigits: Int {
        set { self._valueFormatter.minFractionDigits = newValue }
        get { self._valueFormatter.minFractionDigits }
    }
    
    @MonadicField
    public var maxFractionDigits: Int {
        set { self._valueFormatter.maxFractionDigits = newValue }
        get { self._valueFormatter.maxFractionDigits }
    }
    
    @MonadicField
    public var zeroSymbol: String {
        set { self._valueFormatter.zeroSymbol = newValue }
        get { self._valueFormatter.zeroSymbol }
    }
    
    @MonadicField
    public var nanSymbol: String {
        set { self._valueFormatter.nanSymbol = newValue }
        get { self._valueFormatter.nanSymbol }
    }
    
    @MonadicField
    public var plusSign: String {
        set { self._valueFormatter.plusSign = newValue }
        get { self._valueFormatter.plusSign }
    }
    
    @MonadicField
    public var minusSign: String {
        set { self._valueFormatter.minusSign = newValue }
        get { self._valueFormatter.minusSign }
    }
    
    @MonadicField
    public var positivePrefix: String {
        set { self._valueFormatter.positivePrefix = newValue }
        get { self._valueFormatter.positivePrefix }
    }
    
    @MonadicField
    public var positiveSuffix: String {
        set { self._valueFormatter.positiveSuffix = newValue }
        get { self._valueFormatter.positiveSuffix }
    }
    
    @MonadicField
    public var negativePrefix: String {
        set { self._valueFormatter.negativePrefix = newValue }
        get { self._valueFormatter.negativePrefix }
    }
    
    @MonadicField
    public var negativeSuffix: String {
        set { self._valueFormatter.negativeSuffix = newValue }
        get { self._valueFormatter.negativeSuffix }
    }
    
    @MonadicField
    public var positiveInfinitySymbol: String {
        set { self._valueFormatter.positiveInfinitySymbol = newValue }
        get { self._valueFormatter.positiveInfinitySymbol }
    }
    
    @MonadicField
    public var negativeInfinitySymbol: String {
        set { self._valueFormatter.negativeInfinitySymbol = newValue }
        get { self._valueFormatter.negativeInfinitySymbol }
    }
    
    @MonadicField
    public var alwaysShowsDecimalSeparator: Bool {
        set { self._valueFormatter.alwaysShowsDecimalSeparator = newValue }
        get { self._valueFormatter.alwaysShowsDecimalSeparator }
    }
    
    @MonadicField
    public var decimalSeparator: String {
        set { self._valueFormatter.decimalSeparator = newValue }
        get { self._valueFormatter.decimalSeparator }
    }
    
    @MonadicField
    public var usesGroupingSeparator: Bool {
        set { self._valueFormatter.usesGroupingSeparator = newValue }
        get { self._valueFormatter.usesGroupingSeparator }
    }
    
    @MonadicField
    public var groupingSeparator: String {
        set { self._valueFormatter.groupingSeparator = newValue }
        get { self._valueFormatter.groupingSeparator }
    }
    
    @MonadicField
    public var groupingSize: Int {
        set { self._valueFormatter.groupingSize = newValue }
        get { self._valueFormatter.groupingSize }
    }
    
    @MonadicField
    public var secondaryGroupingSize: Int {
        set { self._valueFormatter.secondaryGroupingSize = newValue }
        get { self._valueFormatter.secondaryGroupingSize }
    }
    
    @MonadicField
    public var locale: Locale {
        set { self._valueFormatter.locale = newValue }
        get { self._valueFormatter.locale }
    }

    private let _valueFormatter = KindString.FloatingPointFormatter< Quantity.Value >()
    private let _unitFormatter = UnitFormatter< Quantity.Unit >()
    
    public init(_ unit: Quantity.Unit) {
        self.unit = unit
    }
    
    public func format(_ input: Quantity) -> String {
        let value = self._valueFormatter.format(input.value(to: self.unit))
        guard value.isEmpty == false else {
            return ""
        }
        let unit = self._unitFormatter.format(self.unit)
        guard unit.isEmpty == false else {
            return value
        }
        return "\(value) \(unit)"
    }
    
}

extension FloatingPointFormatter : Equatable {
    
    public static func == (lhs: FloatingPointFormatter, rhs: FloatingPointFormatter) -> Bool {
        return lhs === rhs
    }
    
}
