//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@Monadic
public final class FloatingPointFormatter< Input : BinaryFloatingPoint > : FormatterTrait {
    
    public let formatter = NumberFormatter()
    
    @MonadicField
    public var minIntegerDigits: Int {
        set { self.formatter.minimumIntegerDigits = newValue }
        get { self.formatter.minimumIntegerDigits }
    }
    
    @MonadicField
    public var maxIntegerDigits: Int {
        set { self.formatter.maximumIntegerDigits = newValue }
        get { self.formatter.maximumIntegerDigits }
    }
    
    @MonadicField
    public var minFractionDigits: Int {
        set { self.formatter.minimumFractionDigits = newValue }
        get { self.formatter.minimumFractionDigits }
    }
    
    @MonadicField
    public var maxFractionDigits: Int {
        set { self.formatter.maximumFractionDigits = newValue }
        get { self.formatter.maximumFractionDigits }
    }
    
    @MonadicField
    public var zeroSymbol: String {
        set { self.formatter.zeroSymbol = newValue }
        get { self.formatter.zeroSymbol ?? "" }
    }
    
    @MonadicField
    public var nanSymbol: String {
        set { self.formatter.notANumberSymbol = newValue }
        get { self.formatter.notANumberSymbol }
    }
    
    @MonadicField
    public var plusSign: String {
        set { self.formatter.plusSign = newValue }
        get { self.formatter.plusSign }
    }
    
    @MonadicField
    public var minusSign: String {
        set { self.formatter.minusSign = newValue }
        get { self.formatter.minusSign }
    }
    
    @MonadicField
    public var positivePrefix: String {
        set { self.formatter.positivePrefix = newValue }
        get { self.formatter.positivePrefix }
    }
    
    @MonadicField
    public var positiveSuffix: String {
        set { self.formatter.positiveSuffix = newValue }
        get { self.formatter.positiveSuffix }
    }
    
    @MonadicField
    public var negativePrefix: String {
        set { self.formatter.negativePrefix = newValue }
        get { self.formatter.negativePrefix }
    }
    
    @MonadicField
    public var negativeSuffix: String {
        set { self.formatter.negativeSuffix = newValue }
        get { self.formatter.negativeSuffix }
    }
    
    @MonadicField
    public var positiveInfinitySymbol: String {
        set { self.formatter.positiveInfinitySymbol = newValue }
        get { self.formatter.positiveInfinitySymbol }
    }
    
    @MonadicField
    public var negativeInfinitySymbol: String {
        set { self.formatter.negativeInfinitySymbol = newValue }
        get { self.formatter.negativeInfinitySymbol }
    }
    
    @MonadicField
    public var alwaysShowsDecimalSeparator: Bool {
        set { self.formatter.alwaysShowsDecimalSeparator = newValue }
        get { self.formatter.alwaysShowsDecimalSeparator }
    }
    
    @MonadicField
    public var decimalSeparator: String {
        set { self.formatter.decimalSeparator = newValue }
        get { self.formatter.decimalSeparator }
    }
    
    @MonadicField
    public var usesGroupingSeparator: Bool {
        set { self.formatter.usesGroupingSeparator = newValue }
        get { self.formatter.usesGroupingSeparator }
    }
    
    @MonadicField
    public var groupingSeparator: String {
        set { self.formatter.groupingSeparator = newValue }
        get { self.formatter.groupingSeparator }
    }
    
    @MonadicField
    public var groupingSize: Int {
        set { self.formatter.groupingSize = newValue }
        get { self.formatter.groupingSize }
    }
    
    @MonadicField
    public var secondaryGroupingSize: Int {
        set { self.formatter.secondaryGroupingSize = newValue }
        get { self.formatter.secondaryGroupingSize }
    }
    
    @MonadicField
    public var locale: Locale {
        set { self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
    public init() {
        self.formatter.numberStyle = .decimal
    }
    
    public func format(_ input: Input) -> String {
        if let value = Swift.Float(exactly: input) {
            if let string = self.formatter.string(from: NSNumber(value: value)) {
                return string
            }
        } else if let value = Swift.Double(exactly: input) {
            if let string = self.formatter.string(from: NSNumber(value: value)) {
                return string
            }
        }
        if let string = self.formatter.notANumberSymbol {
            return string
        } else if let string = self.formatter.zeroSymbol {
            return string
        }
        return self.formatter.nilSymbol
    }
    
}

extension FloatingPointFormatter : Equatable {
    
    public static func == (lhs: FloatingPointFormatter, rhs: FloatingPointFormatter) -> Bool {
        return lhs === rhs
    }
    
}
