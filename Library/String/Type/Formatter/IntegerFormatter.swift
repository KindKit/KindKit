//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@Monadic
public final class IntegerFormatter< Input : BinaryInteger > : FormatterTrait {
    
    public let formatter: NumberFormatter
    
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
    public var zeroSymbol: String {
        set { self.formatter.zeroSymbol = newValue }
        get { self.formatter.zeroSymbol ?? "" }
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
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = .decimal
    }
    
    public func format(_ input: Input) -> String {
        if let value = Swift.Int(exactly: input) {
            if let string = self.formatter.string(from: NSNumber(value: value)) {
                return string
            }
        } else if let value = Swift.UInt(exactly: input) {
            if let string = self.formatter.string(from: NSNumber(value: value)) {
                return string
            }
        }
        if let string = self.formatter.zeroSymbol {
            return string
        }
        return self.formatter.nilSymbol
    }
    
}

extension IntegerFormatter : Equatable {
    
    public static func == (lhs: IntegerFormatter, rhs: IntegerFormatter) -> Bool {
        return lhs === rhs
    }
    
}
