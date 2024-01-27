//
//  KindKit
//

import KindString

extension LettersComponent {
    
    init(
        info: Info,
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) {
        self.init(info.build(
            options: options,
            head: head,
            inter: inter,
            tail: tail
        ))
    }
    
    init< Info : KindDebug.Info >(
        info: Info,
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) {
        self.init(info.build(
            options: options,
            head: head,
            inter: inter,
            tail: tail
        ))
    }
    
}
