//
//  KindKit
//

import Foundation

public extension Formatter.String {

    struct Double< InputType : BinaryFloatingPoint > : IFormatter, Equatable {
        
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

public extension Formatter.String.Double {
    
    @inlinable
    var minIntegerDigits: Int {
        nonmutating set {  self.formatter.minimumIntegerDigits = newValue }
        get { self.formatter.minimumIntegerDigits }
    }
    
    @inlinable
    var maxIntegerDigits: Int {
        nonmutating set {  self.formatter.maximumIntegerDigits = newValue }
        get { self.formatter.maximumIntegerDigits }
    }
    
    @inlinable
    var minFractionDigits: Int {
        nonmutating set {  self.formatter.minimumFractionDigits = newValue }
        get { self.formatter.minimumFractionDigits }
    }
    
    @inlinable
    var maxFractionDigits: Int {
        nonmutating set {  self.formatter.maximumFractionDigits = newValue }
        get { self.formatter.maximumFractionDigits }
    }
    
    @inlinable
    var zeroSymbol: String {
        nonmutating set {  self.formatter.zeroSymbol = newValue }
        get { self.formatter.zeroSymbol ?? "" }
    }
    
    @inlinable
    var nanSymbol: String {
        nonmutating set {  self.formatter.notANumberSymbol = newValue }
        get { self.formatter.notANumberSymbol }
    }
    
    @inlinable
    var plusSign: String {
        nonmutating set {  self.formatter.plusSign = newValue }
        get { self.formatter.plusSign }
    }
    
    @inlinable
    var minusSign: String {
        nonmutating set {  self.formatter.minusSign = newValue }
        get { self.formatter.minusSign }
    }
    
    @inlinable
    var positivePrefix: String {
        nonmutating set {  self.formatter.positivePrefix = newValue }
        get { self.formatter.positivePrefix }
    }
    
    @inlinable
    var positiveSuffix: String {
        nonmutating set {  self.formatter.positiveSuffix = newValue }
        get { self.formatter.positiveSuffix }
    }
    
    @inlinable
    var negativePrefix: String {
        nonmutating set {  self.formatter.negativePrefix = newValue }
        get { self.formatter.negativePrefix }
    }
    
    @inlinable
    var negativeSuffix: String {
        nonmutating set {  self.formatter.negativeSuffix = newValue }
        get { self.formatter.negativeSuffix }
    }
    
    @inlinable
    var positiveInfinitySymbol: String {
        nonmutating set {  self.formatter.positiveInfinitySymbol = newValue }
        get { self.formatter.positiveInfinitySymbol }
    }
    
    @inlinable
    var negativeInfinitySymbol: String {
        nonmutating set {  self.formatter.negativeInfinitySymbol = newValue }
        get { self.formatter.negativeInfinitySymbol }
    }
    
    @inlinable
    var alwaysShowsDecimalSeparator: Bool {
        nonmutating set {  self.formatter.alwaysShowsDecimalSeparator = newValue }
        get { self.formatter.alwaysShowsDecimalSeparator }
    }
    
    @inlinable
    var decimalSeparator: String {
        nonmutating set {  self.formatter.decimalSeparator = newValue }
        get { self.formatter.decimalSeparator }
    }
    
    @inlinable
    var usesGroupingSeparator: Bool {
        nonmutating set {  self.formatter.usesGroupingSeparator = newValue }
        get { self.formatter.usesGroupingSeparator }
    }
    
    @inlinable
    var groupingSeparator: String {
        nonmutating set {  self.formatter.groupingSeparator = newValue }
        get { self.formatter.groupingSeparator }
    }
    
    @inlinable
    var groupingSize: Int {
        nonmutating set {  self.formatter.groupingSize = newValue }
        get { self.formatter.groupingSize }
    }
    
    @inlinable
    var secondaryGroupingSize: Int {
        nonmutating set {  self.formatter.secondaryGroupingSize = newValue }
        get { self.formatter.secondaryGroupingSize }
    }
    
    @inlinable
    var locale: Locale {
        nonmutating set {  self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
}

public extension Formatter.String.Double {
    
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
    func minFractionDigits(_ value: Int) -> Self {
        self.minFractionDigits = value
        return self
    }
    
    @inlinable
    @discardableResult
    func maxFractionDigits(_ value: Int) -> Self {
        self.maxFractionDigits = value
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
    func nanSymbol(_ value: String) -> Self {
        self.nanSymbol = value
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
    func positiveInfinity(_ value: String) -> Self {
        self.positiveInfinitySymbol = value
        return self
    }
    
    @inlinable
    @discardableResult
    func negativeInfinitySymbol(_ value: String) -> Self {
        self.negativeInfinitySymbol = value
        return self
    }
    
    @inlinable
    @discardableResult
    func alwaysShowsDecimalSeparator(_ value: Bool) -> Self {
        self.alwaysShowsDecimalSeparator = value
        return self
    }
    
    @inlinable
    @discardableResult
    func decimalSeparator(_ value: String) -> Self {
        self.decimalSeparator = value
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

public extension IFormatter where Self == Formatter.String.Double< Swift.Float > {
    
    static func float() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Double< Swift.Double > {
    
    static func double() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Double< Swift.Float32 > {
    
    static func float32() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Double< Swift.Float64 > {
    
    static func double64() -> Self {
        return .init()
    }
    
}

public extension BinaryFloatingPoint {
    
    @inlinable
    func kk_format(floatingPoint formatter: Formatter.String.Double< Self >) -> String {
        return formatter.format(self)
    }
    
}
