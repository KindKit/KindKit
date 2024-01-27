//
//  KindKit
//

import KindGraphics
import KindStringFormat

public struct StringArgument : Argument {
    
    public let options: Options

    private let _internal: KindStringFormat.StringArgument
    
    public init(_ value: String, options: Options, fallback: String = "") {
        self.options = options
        self._internal = .init(value, fallback: fallback)
    }
    
    public func string(_ specifier: Specifier) -> String {
        return self._internal.string(specifier)
    }
    
}
