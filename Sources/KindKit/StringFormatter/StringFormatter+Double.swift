//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct Double< InputType : BinaryFloatingPoint > : IStringFormatter, Equatable {
        
        public let formatter: NumberFormatter
        
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

}

public extension StringFormatter.Double {
    
    @inlinable
    var minIntegerDigits: Int {
        return self.formatter.minimumIntegerDigits
    }
    
    @inlinable
    var maxIntegerDigits: Int {
        return self.formatter.maximumIntegerDigits
    }
    
    @inlinable
    var minFractionDigits: Int {
        return self.formatter.minimumFractionDigits
    }
    
    @inlinable
    var maxFractionDigits: Int {
        return self.formatter.maximumFractionDigits
    }
    
    @inlinable
    var zero: String {
        return self.formatter.zeroSymbol ?? ""
    }
    
    @inlinable
    var nan: String {
        return self.formatter.notANumberSymbol
    }
    
    @inlinable
    var plusSign: String {
        return self.formatter.plusSign
    }
    
    @inlinable
    var minusSign: String {
        return self.formatter.minusSign
    }
    
    @inlinable
    var positivePrefix: String {
        return self.formatter.positivePrefix
    }
    
    @inlinable
    var positiveSuffix: String {
        return self.formatter.positiveSuffix
    }
    
    @inlinable
    var negativePrefix: String {
        return self.formatter.negativePrefix
    }
    
    @inlinable
    var negativeSuffix: String {
        return self.formatter.negativeSuffix
    }
    
    @inlinable
    var positiveInfinity: String {
        return self.formatter.positiveInfinitySymbol
    }
    
    @inlinable
    var negativeInfinity: String {
        return self.formatter.negativeInfinitySymbol
    }
    
    @inlinable
    var alwaysShowsDecimalSeparator: Bool {
        return self.formatter.alwaysShowsDecimalSeparator
    }
    
    @inlinable
    var decimalSeparator: String {
        return self.formatter.decimalSeparator
    }
    
    @inlinable
    var usesGroupingSeparator: Bool {
        return self.formatter.usesGroupingSeparator
    }
    
    @inlinable
    var groupingSeparator: String {
        self.formatter.groupingSeparator
    }
    
    @inlinable
    var groupingSize: Int {
        return self.formatter.groupingSize
    }
    
    @inlinable
    var secondaryGroupingSize: Int {
        return self.formatter.secondaryGroupingSize
    }
    
    @inlinable
    var locale: Locale {
        return self.formatter.locale
    }
    
}

public extension StringFormatter.Double {
    
    @inlinable
    func minIntegerDigits(_ value: Int) -> Self {
        self.formatter.minimumIntegerDigits = value
        return self
    }
    
    @inlinable
    func maxIntegerDigits(_ value: Int) -> Self {
        self.formatter.maximumIntegerDigits = value
        return self
    }
    
    @inlinable
    func minFractionDigits(_ value: Int) -> Self {
        self.formatter.minimumFractionDigits = value
        return self
    }
    
    @inlinable
    func maxFractionDigits(_ value: Int) -> Self {
        self.formatter.maximumFractionDigits = value
        return self
    }
    
    @inlinable
    func zero(_ value: String) -> Self {
        self.formatter.zeroSymbol = value
        return self
    }
    
    @inlinable
    func nan(_ value: String) -> Self {
        self.formatter.notANumberSymbol = value
        return self
    }
    
    @inlinable
    func plusSign(_ value: String) -> Self {
        self.formatter.plusSign = value
        return self
    }
    
    @inlinable
    func minusSign(_ value: String) -> Self {
        self.formatter.minusSign = value
        return self
    }
    
    @inlinable
    func positivePrefix(_ value: String) -> Self {
        self.formatter.positivePrefix = value
        return self
    }
    
    @inlinable
    func positiveSuffix(_ value: String) -> Self {
        self.formatter.positiveSuffix = value
        return self
    }
    
    @inlinable
    func negativePrefix(_ value: String) -> Self {
        self.formatter.negativePrefix = value
        return self
    }
    
    @inlinable
    func negativeSuffix(_ value: String) -> Self {
        self.formatter.negativeSuffix = value
        return self
    }
    
    @inlinable
    func positiveInfinity(_ value: String) -> Self {
        self.formatter.positiveInfinitySymbol = value
        return self
    }
    
    @inlinable
    func negativeInfinity(_ value: String) -> Self {
        self.formatter.negativeInfinitySymbol = value
        return self
    }
    
    @inlinable
    func alwaysShowsDecimalSeparator(_ value: Bool) -> Self {
        self.formatter.alwaysShowsDecimalSeparator = value
        return self
    }
    
    @inlinable
    func decimalSeparator(_ value: String) -> Self {
        self.formatter.decimalSeparator = value
        return self
    }
    
    @inlinable
    func usesGroupingSeparator(_ value: Bool) -> Self {
        self.formatter.usesGroupingSeparator = value
        return self
    }
    
    @inlinable
    func groupingSeparator(_ value: String) -> Self {
        self.formatter.groupingSeparator = value
        return self
    }
    
    @inlinable
    func groupingSize(_ value: Int) -> Self {
        self.formatter.groupingSize = value
        return self
    }
    
    @inlinable
    func secondaryGroupingSize(_ value: Int) -> Self {
        self.formatter.secondaryGroupingSize = value
        return self
    }
    
    @inlinable
    func locale(_ value: Locale) -> Self {
        self.formatter.locale = value
        return self
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Double< Swift.Float > {
    
    static func float() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Double< Swift.Double > {
    
    static func double() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Double< Swift.Float32 > {
    
    static func float32() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Double< Swift.Float64 > {
    
    static func double64() -> Self {
        return .init()
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    func kk_format(floatingPoint formatter: StringFormatter.Double< Self >) -> String {
        return formatter.format(self)
    }
    
}
