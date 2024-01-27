//
//  KindKit
//

import KindGraphics
import KindStringFormat

public struct FloatingPointArgument< ValueType : BinaryFloatingPoint > : IArgument {
    
    public let options: Text.Options

    private let _internal: KindStringFormat.FloatingPointArgument< ValueType >
    
    public init(_ value: ValueType, options: Text.Options, fallback: String = "") {
        self.options = options
        self._internal = .init(value, fallback: fallback)
    }
    
    public func string(_ specifier: Specifier) -> String {
        return self._internal.string(specifier)
    }
    
}
