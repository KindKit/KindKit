//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct Double< InputType : BinaryFloatingPoint > : IStringFormatter {
        
        public let formatter: NumberFormatter
        
        public init(
            minIntegerDigits: Int? = nil,
            maxIntegerDigits: Int? = nil,
            minFractionDigits: Int? = nil,
            maxFractionDigits: Int? = nil,
            zero: String? = nil,
            nan: String? = nil,
            plusSign: String? = nil,
            minusSign: String? = nil,
            positivePrefix: String? = nil,
            positiveSuffix: String? = nil,
            negativePrefix: String? = nil,
            negativeSuffix: String? = nil,
            positiveInfinity: String? = nil,
            negativeInfinity: String? = nil,
            alwaysShowsDecimalSeparator: Bool? = nil,
            decimalSeparator: String? = nil,
            usesGroupingSeparator: Bool? = nil,
            groupingSeparator: String? = nil,
            groupingSize: Int? = nil,
            secondaryGroupingSize: Int? = nil,
            locale: Locale = Locale.current
        ) {
            self.formatter = NumberFormatter()
            self.formatter.numberStyle = .decimal
            self.formatter.locale = locale
            if let minIntegerDigits = minIntegerDigits {
                self.formatter.minimumIntegerDigits = minIntegerDigits
            }
            if let maxIntegerDigits = maxIntegerDigits {
                self.formatter.maximumIntegerDigits = maxIntegerDigits
            }
            if let minFractionDigits = minFractionDigits {
                self.formatter.minimumFractionDigits = minFractionDigits
            }
            if let maxFractionDigits = maxFractionDigits {
                self.formatter.maximumFractionDigits = maxFractionDigits
            }
            if let zero = zero {
                self.formatter.zeroSymbol = zero
            }
            if let nan = nan {
                self.formatter.notANumberSymbol = nan
            }
            if let plusSign = plusSign {
                self.formatter.plusSign = plusSign
            }
            if let minusSign = minusSign {
                self.formatter.zeroSymbol = minusSign
            }
            if let positivePrefix = positivePrefix {
                self.formatter.positivePrefix = positivePrefix
            }
            if let positiveSuffix = positiveSuffix {
                self.formatter.positiveSuffix = positiveSuffix
            }
            if let negativePrefix = negativePrefix {
                self.formatter.negativePrefix = negativePrefix
            }
            if let negativeSuffix = negativeSuffix {
                self.formatter.negativeSuffix = negativeSuffix
            }
            if let positiveInfinity = positiveInfinity {
                self.formatter.positiveInfinitySymbol = positiveInfinity
            }
            if let negativeInfinity = negativeInfinity {
                self.formatter.negativeInfinitySymbol = negativeInfinity
            }
            if let alwaysShowsDecimalSeparator = alwaysShowsDecimalSeparator {
                self.formatter.alwaysShowsDecimalSeparator = alwaysShowsDecimalSeparator
            }
            if let decimalSeparator = decimalSeparator {
                self.formatter.decimalSeparator = decimalSeparator
            }
            if let usesGroupingSeparator = usesGroupingSeparator {
                self.formatter.usesGroupingSeparator = usesGroupingSeparator
            }
            if let groupingSeparator = groupingSeparator {
                self.formatter.groupingSeparator = groupingSeparator
            }
            if let groupingSize = groupingSize {
                self.formatter.groupingSize = groupingSize
            }
            if let secondaryGroupingSize = secondaryGroupingSize {
                self.formatter.secondaryGroupingSize = secondaryGroupingSize
            }
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
