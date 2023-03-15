//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct Integer< InputType : BinaryInteger > : IStringFormatter {
        
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

public extension StringFormatter.Integer {
    
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
    func zero(_ value: String) -> Self {
        self.formatter.zeroSymbol = value
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

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.Int > {
    
    static func int() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.UInt > {
    
    static func uint() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.Int8 > {
    
    static func int8() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.Int16 > {
    
    static func int16() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.Int32 > {
    
    static func int32() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.Int64 > {
    
    static func int64() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.UInt8 > {
    
    static func uint8() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.UInt16 > {
    
    static func uint16() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.UInt32 > {
    
    static func uint32() -> Self {
        return .init()
    }
    
}

public extension IStringFormatter where Self == StringFormatter.Integer< Swift.UInt64 > {
    
    static func uint64() -> Self {
        return .init()
    }
    
}
