//
//  KindKit
//

import KindStringPattern

public struct FormatComponent : KindString.Component {
    
    public let string: String
    
    public init(
        format: String,
        @ArgumentsBuilder arguments: () -> [any Argument]
    ) {
        do {
            self.string = try KindStringFormat.format(
                accumulator: StringAccumulator(),
                formatter: StringFormatter(),
                input: format,
                arguments: arguments()
            )
        } catch {
            self.string = format
        }
    }
    
    public init(
        @Builder format: () -> String,
        @ArgumentsBuilder arguments: () -> [Argument]
    ) {
        self.init(
            format: format(),
            arguments: arguments
        )
    }
    
}
