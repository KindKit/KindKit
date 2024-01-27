//
//  KindKit
//

import KindCore

public struct FormatterComponent : IComponent {
    
    public let string: String
    
    public init< FormatterType : IFormatter >(
        source: FormatterType.InputType,
        formatter: FormatterType
    ) where FormatterType.OutputType == String {
        self.string = formatter.format(source)
    }
    
}
