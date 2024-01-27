//
//  KindKit
//

import KindString

extension String : IEntity {
    
    public func debugInfo() -> Info {
        return .string(builder: {
            QuoteComponent(.double, content: {
                LettersComponent(self, escape: [ .tab, .newline, .return, .doubleQuote ])
            })
        })
    }

}
