//
//  KindKit
//

import KindGraphics
import KindStringFormat
import KindStringPattern

public struct FormatComponent : Component {
    
    public let part: Text.Part
    
    public init(
        options: Options = .empty,
        format: String,
        @ArgumentsBuilder arguments: () -> [any Argument]
    ) {
        do {
            self.part = try KindStringFormat.format(
                accumulator: TextAccumulator(options: options),
                formatter: TextFormatter(options: options),
                input: format,
                arguments: arguments()
            )
        } catch {
            self.part = .init(format)
        }
    }
    
    public init(
        options: Options = .empty,
        @Builder format: () -> String,
        @ArgumentsBuilder arguments: () -> [any Argument]
    ) {
        self.init(
            options: options,
            format: format(),
            arguments: arguments
        )
    }
    
}
