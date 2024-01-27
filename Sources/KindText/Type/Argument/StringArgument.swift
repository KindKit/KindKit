//
//  KindKit
//

import KindGraphics
import KindStringFormat

public struct StringArgument : IArgument {
    
    public let options: Text.Options

    private let _internal: KindStringFormat.StringArgument
    
    public init(_ value: String, options: Text.Options, fallback: String = "") {
        self.options = options
        self._internal = .init(value, fallback: fallback)
    }
    
    public func string(_ specifier: Specifier) -> String {
        return self._internal.string(specifier)
    }
    
}
