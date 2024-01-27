//
//  KindKit
//

@_exported import KindCore
@_exported import KindString

import KindStringScanner

public func format<
    AccumulatorType : IAccumulator,
    FormatterType : KindStringFormat.IFormatter,
    ArgumentsType : RandomAccessCollection
>(
    accumulator: AccumulatorType,
    formatter: FormatterType,
    input: String,
    arguments: ArgumentsType
) throws -> AccumulatorType.ResultType where AccumulatorType.PartType == FormatterType.ResultType, FormatterType.ArgumentType == ArgumentsType.Element {
    var argumentIndex = arguments.startIndex
    let pattern = KindStringScanner.Pattern(Pattern.patterns)
    return try pattern.replace(accumulator: accumulator, input: input, format: { match in
        guard let specifier = Specifier(match) else {
            return formatter.undefined()
        }
        if let placeholder = specifier.placeholder {
            return formatter.placeholder(placeholder)
        } else {
            let argument: FormatterType.ArgumentType?
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
