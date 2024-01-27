//
//  KindKit
//

import KindStringScanner

public struct FormatComponent : KindString.IComponent {
    
    public let string: String
    
    public init(
        format: String,
        @ArgumentsBuilder arguments: () -> [IArgument]
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
        @ArgumentsBuilder arguments: () -> [IArgument]
    ) {
        self.init(
            format: format(),
            arguments: arguments
        )
    }
    
}
