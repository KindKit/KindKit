//
//  KindKit
//

import Foundation

public extension Formatter.String {

    struct Integer< InputType : BinaryInteger > : IFormatter, Equatable {
        
        public let formatter: NumberFormatter
        
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

}

public extension Formatter.String.Integer {
    
    @inlinable
    var minIntegerDigits: Int {
        nonmutating set { self.formatter.minimumIntegerDigits = newValue }
        get { self.formatter.minimumIntegerDigits }
    }
    
    @inlinable
    var maxIntegerDigits: Int {
        nonmutating set { self.formatter.maximumIntegerDigits = newValue }
        get { self.formatter.maximumIntegerDigits }
    }
    
    @inlinable
    var zeroSymbol: String {
        nonmutating set { self.formatter.zeroSymbol = newValue }
        get { self.formatter.zeroSymbol ?? "" }
    }
    
    @inlinable
    var plusSign: String {
        nonmutating set { self.formatter.plusSign = newValue }
        get { self.formatter.plusSign }
    }
    
    @inlinable
    var minusSign: String {
        nonmutating set { self.formatter.minusSign = newValue }
        get { self.formatter.minusSign }
    }
    
    @inlinable
    var positivePrefix: String {
        nonmutating set { self.formatter.positivePrefix = newValue }
        get { self.formatter.positivePrefix }
    }
    
    @inlinable
    var positiveSuffix: String {
        nonmutating set { self.formatter.positiveSuffix = newValue }
        get { self.formatter.positiveSuffix }
    }
    
    @inlinable
    var negativePrefix: String {
        nonmutating set { self.formatter.negativePrefix = newValue }
        get { self.formatter.negativePrefix }
    }
    
    @inlinable
    var negativeSuffix: String {
        nonmutating set { self.formatter.negativeSuffix = newValue }
        get { self.formatter.negativeSuffix }
    }
    
    @inlinable
    var usesGroupingSeparator: Bool {
        nonmutating set { self.formatter.usesGroupingSeparator = newValue }
        get { self.formatter.usesGroupingSeparator }
    }
    
    @inlinable
    var groupingSeparator: String {
        nonmutating set { self.formatter.groupingSeparator = newValue }
        get { self.formatter.groupingSeparator }
    }
    
    @inlinable
    var groupingSize: Int {
        nonmutating set { self.formatter.groupingSize = newValue }
        get { self.formatter.groupingSize }
    }
    
    @inlinable
    var secondaryGroupingSize: Int {
        nonmutating set { self.formatter.secondaryGroupingSize = newValue }
        get { self.formatter.secondaryGroupingSize }
    }
    
    @inlinable
    var locale: Locale {
        nonmutating set { self.formatter.locale = newValue }
        get { self.formatter.locale }
    }
    
}

public extension Formatter.String.Integer {
    
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

public extension IFormatter where Self == Formatter.String.Integer< Swift.Int > {
    
    static func int() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.UInt > {
    
    static func uint() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.Int8 > {
    
    static func int8() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.Int16 > {
    
    static func int16() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.Int32 > {
    
    static func int32() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.Int64 > {
    
    static func int64() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.UInt8 > {
    
    static func uint8() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.UInt16 > {
    
    static func uint16() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.UInt32 > {
    
    static func uint32() -> Self {
        return .init()
    }
    
}

public extension IFormatter where Self == Formatter.String.Integer< Swift.UInt64 > {
    
    static func uint64() -> Self {
        return .init()
    }
    
}

public extension BinaryInteger {
    
    @inlinable
    func kk_format(integer formatter: Formatter.String.Integer< Self >) -> String {
        return formatter.format(self)
    }
    
}
