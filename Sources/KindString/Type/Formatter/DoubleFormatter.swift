//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@KindMonadic
public final class DoubleFormatter< InputType : BinaryFloatingPoint > : IFormatter {
    
    public let formatter: NumberFormatter
    
    @KindMonadicProperty
    public var minIntegerDigits: Int {
        set {  self.formatter.minimumIntegerDigits = newValue }
        get { self.formatter.minimumIntegerDigits }
    }
    
    @KindMonadicProperty
    public var maxIntegerDigits: Int {
        set {  self.formatter.maximumIntegerDigits = newValue }
        get { self.formatter.maximumIntegerDigits }
    }
    
    @KindMonadicProperty
    public var minFractionDigits: Int {
        set {  self.formatter.minimumFractionDigits = newValue }
        get { self.formatter.minimumFractionDigits }
    }
    
    @KindMonadicProperty
    public var maxFractionDigits: Int {
        set {  self.formatter.maximumFractionDigits = newValue }
        get { self.formatter.maximumFractionDigits }
    }
    
    @KindMonadicProperty
    public var zeroSymbol: String {
        set {  self.formatter.zeroSymbol = newValue }
        get { self.formatter.zeroSymbol ?? "" }
    }
    
    @KindMonadicProperty
    public var nanSymbol: String {
        set {  self.formatter.notANumberSymbol = newValue }
        get { self.formatter.notANumberSymbol }
    }
    
    @KindMonadicProperty
    public var plusSign: String {
        set {  self.formatter.plusSign = newValue }
        get { self.formatter.plusSign }
    }
    
    @KindMonadicProperty
    public var minusSign: String {
        set {  self.formatter.minusSign = newValue }
        get { self.formatter.minusSign }
    }
    
    @KindMonadicProperty
    public var positivePrefix: String {
        set {  self.formatter.positivePrefix = newValue }
        get { self.formatter.positivePrefix }
    }
    
    @KindMonadicProperty
    public var positiveSuffix: String {
        set {  self.formatter.positiveSuffix = newValue }
        get { self.formatter.positiveSuffix }
    }
    
    @KindMonadicProperty
    public var negativePrefix: String {
        set {  self.formatter.negativePrefix = newValue }
        get { self.formatter.negativePrefix }
    }
    
    @KindMonadicProperty
    public var negativeSuffix: String {
        set {  self.formatter.negativeSuffix = newValue }
        get { self.formatter.negativeSuffix }
    }
    
    @KindMonadicProperty
    public var positiveInfinitySymbol: String {
        set {  self.formatter.positiveInfinitySymbol = newValue }
        get { self.formatter.positiveInfinitySymbol }
    }
    
    @KindMonadicProperty
    public var negativeInfinitySymbol: String {
        set {  self.formatter.negativeInfinitySymbol = newValue }
        get { self.formatter.negativeInfinitySymbol }
    }
    
    @KindMonadicProperty
    public var alwaysShowsDecimalSeparator: Bool {
        set {  self.formatter.alwaysShowsDecimalSeparator = newValue }
        get { self.formatter.alwaysShowsDecimalSeparator }
    }
    
    @KindMonadicProperty
    public var decimalSeparator: String {
        set {  self.formatter.decimalSeparator = newValue }
        get { self.formatter.decimalSeparator }
    }
    
    @KindMonadicProperty
    public var usesGroupingSeparator: Bool {
        set {  self.formatter.usesGroupingSeparator = newValue }
        get { self.formatter.usesGroupingSeparator }
    }
    
    @KindMonadicProperty
    public var groupingSeparator: String {
        set {  self.formatter.groupingSeparator = newValue }
        get { self.formatter.groupingSeparator }
    }
    
    @KindMonadicProperty
    public var groupingSize: Int {
        set {  self.formatter.groupingSize = newValue }
        get { self.formatter.groupingSize }
    }
    
    @KindMonadicProperty
    public var secondaryGroupingSize: Int {
        set {  self.formatter.secondaryGroupingSize = newValue }
        get { self.formatter.secondaryGroupingSize }
    }
    
    @KindMonadicProperty
    public var locale: Locale {
        set {  self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
    public init() {
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = .decimal
    }
    
    public func format(_ input: InputType) -> String {
        if let value = Swift.Double(exactly: input) {
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

extension DoubleFormatter : Equatable {
    
    public static func == (lhs: DoubleFormatter, rhs: DoubleFormatter) -> Bool {
        return lhs === rhs
    }
    
}
