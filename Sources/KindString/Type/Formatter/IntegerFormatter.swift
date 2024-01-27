//
//  KindKit
//

import Foundation
import KindCore
import KindMonadicMacro

@KindMonadic
public final class IntegerFormatter< InputType : BinaryInteger > : IFormatter {
    
    public let formatter: NumberFormatter
    
    @KindMonadicProperty
    public var minIntegerDigits: Int {
        set { self.formatter.minimumIntegerDigits = newValue }
        get { self.formatter.minimumIntegerDigits }
    }
    
    @KindMonadicProperty
    public var maxIntegerDigits: Int {
        set { self.formatter.maximumIntegerDigits = newValue }
        get { self.formatter.maximumIntegerDigits }
    }
    
    @KindMonadicProperty
    public var zeroSymbol: String {
        set { self.formatter.zeroSymbol = newValue }
        get { self.formatter.zeroSymbol ?? "" }
    }
    
    @KindMonadicProperty
    public var plusSign: String {
        set { self.formatter.plusSign = newValue }
        get { self.formatter.plusSign }
    }
    
    @KindMonadicProperty
    public var minusSign: String {
        set { self.formatter.minusSign = newValue }
        get { self.formatter.minusSign }
    }
    
    @KindMonadicProperty
    public var positivePrefix: String {
        set { self.formatter.positivePrefix = newValue }
        get { self.formatter.positivePrefix }
    }
    
    @KindMonadicProperty
    public var positiveSuffix: String {
        set { self.formatter.positiveSuffix = newValue }
        get { self.formatter.positiveSuffix }
    }
    
    @KindMonadicProperty
    public var negativePrefix: String {
        set { self.formatter.negativePrefix = newValue }
        get { self.formatter.negativePrefix }
    }
    
    @KindMonadicProperty
    public var negativeSuffix: String {
        set { self.formatter.negativeSuffix = newValue }
        get { self.formatter.negativeSuffix }
    }
    
    @KindMonadicProperty
    public var usesGroupingSeparator: Bool {
        set { self.formatter.usesGroupingSeparator = newValue }
        get { self.formatter.usesGroupingSeparator }
    }
    
    @KindMonadicProperty
    public var groupingSeparator: String {
        set { self.formatter.groupingSeparator = newValue }
        get { self.formatter.groupingSeparator }
    }
    
    @KindMonadicProperty
    public var groupingSize: Int {
        set { self.formatter.groupingSize = newValue }
        get { self.formatter.groupingSize }
    }
    
    @KindMonadicProperty
    public var secondaryGroupingSize: Int {
        set { self.formatter.secondaryGroupingSize = newValue }
        get { self.formatter.secondaryGroupingSize }
    }
    
    @KindMonadicProperty
    public var locale: Locale {
        set { self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
    public init() {
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = .decimal
    }
    
    public func format(_ input: InputType) -> String {
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
