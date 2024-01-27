//
//  KindKit
//

import KindStringScanner

public struct Pattern {
    
    private let _pattern: [any Component]
    
    public init(@ComponentsBuilder _ builder: () -> [any Component]) {
        self._pattern = builder()
    }
    
    public func replace< 
        Accumulator : KindStringPattern.Accumulator
    >(
        accumulator: Accumulator,
        input: String,
        format: (Output) -> Accumulator.Part
    ) throws -> Accumulator.Result {
        var inputIndex = input.startIndex
        let scanner = Scanner(input)
        while scanner.isAtEnd == false {
            let scannerIndex = scanner.index
            let context = Context()
            for pattern in self._pattern {
                _ = try pattern.scan(scanner, in: context)
            }
            let match = Output(context)
            if let matchRange = match.range {
                if inputIndex < matchRange.lowerBound {
                    let inputRange = inputIndex ..< matchRange.lowerBound
                    accumulator.append(input: .init(input[inputRange]))
                    inputIndex = matchRange.upperBound
                } else {
                    inputIndex = matchRange.upperBound
                }
                accumulator.append(part: format(match))
            }
            if scanner.index == scannerIndex {
                scanner.next(length: 1)
            }
        }
        if inputIndex != input.endIndex {
            let inputRange = inputIndex ..< input.endIndex
            accumulator.append(input: .init(input[inputRange]))
        }
        return accumulator.result()
    }
    
    public func matches(_ input: String) throws -> [Output] {
        var result: [Output] = []
        let scanner = Scanner(input)
        while scanner.isAtEnd == false {
            let index = scanner.index
            let context = Context()
            for pattern in self._pattern {
                _ = try pattern.scan(scanner, in: context)
            }
            if context.isEmpty == false {
                result.append(.init(context))
            }
            if scanner.index == index {
                scanner.next(length: 1)
            }
        }
        return result
    }
    
    public func match(_ input: String) throws -> Output {
        let scanner = Scanner(input)
        let context = Context()
        while scanner.isAtEnd == false {
            let index = scanner.index
            for pattern in self._pattern {
                _ = try pattern.scan(scanner, in: context)
            }
            if scanner.index == index {
                scanner.next(length: 1)
            }
        }
        return .init(context)
    }
    
}
