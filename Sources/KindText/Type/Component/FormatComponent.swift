//
//  KindKit
//

import KindGraphics
import KindStringFormat
import KindStringScanner

public struct FormatComponent : IComponent {
    
    public let text: Text
    
    public init(
        options: Text.Options = .empty,
        format: String,
        @ArgumentsBuilder arguments: () -> [IArgument]
    ) {
        do {
            self.text = try KindStringFormat.format(
                accumulator: TextAccumulator(options: options),
                formatter: TextFormatter(options: options),
                input: format,
                arguments: arguments()
            )
        } catch {
            self.text = .init(format)
        }
    }
    
    public init(
        options: Text.Options = .empty,
        @Builder format: () -> String,
        @ArgumentsBuilder arguments: () -> [IArgument]
    ) {
        self.init(
            options: options,
            format: format(),
            arguments: arguments
        )
    }
    
}
