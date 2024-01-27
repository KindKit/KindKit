//
//  KindKit
//

import KindGraphics
import KindStringFormat

public struct FloatingPointArgument< Value : BinaryFloatingPoint > : Argument {
    
    public let options: Options

    private let _internal: KindStringFormat.FloatingPointArgument< Value >
    
    public init(_ value: Value, options: Options, fallback: String = "") {
        self.options = options
        self._internal = .init(value, fallback: fallback)
    }
    
    public func string(_ specifier: Specifier) -> String {
        return self._internal.string(specifier)
    }
    
}
