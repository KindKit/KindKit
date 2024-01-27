//
//  KindKit
//

import KindCore

public struct FormatterComponent : Component {
    
    public let string: String
    
    public init< Formatter : FormatterTrait >(
        source: Formatter.Input,
        formatter: Formatter
    ) where Formatter.Output == String {
        self.string = formatter.format(source)
    }
    
}
