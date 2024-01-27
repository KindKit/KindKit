//
//  KindKit
//

import KindString

public struct TupleInfo< Primary : Info, Secondary : Info > : Info {
    
    public let primary: Primary
    public let secondary: Secondary
    
    public init(
        _ primary: Primary,
        _ secondary: Secondary
    ) {
        self.primary = primary
        self.secondary = secondary
    }
    
    @KindString.Builder public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        LettersComponent(
            info: self.primary,
            options: options,
            head: head,
            inter: inter,
            tail: 0
        )
        LettersComponent(
            info: self.secondary,
            options: options,
            head: 0,
            inter: inter,
            tail: tail
        )
    }
    
}
