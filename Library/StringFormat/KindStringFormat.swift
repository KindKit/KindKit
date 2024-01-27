//
//  KindKit
//

@_exported import KindCore
@_exported import KindString

import KindStringScanner
import KindStringPattern

public func format<
    Accumulator : KindStringPattern.Accumulator,
    Formatter : KindStringFormat.Formatter,
    Arguments : RandomAccessCollection
>(
    accumulator: Accumulator,
    formatter: Formatter,
    input: String,
    arguments: Arguments
) throws -> Accumulator.Result where Accumulator.Part == Formatter.Result, Formatter.Argument == Arguments.Element {
    var argumentIndex = arguments.startIndex
    let pattern = KindStringPattern.Pattern(Pattern.patterns)
    return try pattern.replace(accumulator: accumulator, input: input, format: { match in
        guard let specifier = Specifier(match) else {
            return formatter.undefined()
        }
        if let placeholder = specifier.placeholder {
            return formatter.placeholder(placeholder)
        } else {
            let argument: Formatter.Argument?
            switch specifier {
            case .ieee_1003(let specifier):
                switch specifier.index {
                case .auto:
                    if argumentIndex < arguments.endIndex {
                        argument = arguments[argumentIndex]
                        argumentIndex = arguments.index(after: argumentIndex)
                    } else {
                        argument = nil
                    }
                case .custom(let index):
                    let index = arguments.index(arguments.startIndex, offsetBy: .init(index))
                    if index < arguments.endIndex {
                        argument = arguments[index]
                    } else {
                        argument = nil
                    }
                }
            }
            if let argument = argument {
                return formatter.argument(argument, specifier: specifier)
            }
            return formatter.undefined()
        }
        
    })
}
