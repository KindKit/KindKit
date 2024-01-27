//
//  KindKit
//

import KindString

extension String : DebugTrait {
    
    public func buildInfo() -> Info {
        return StringInfo({
            QuoteComponent(.double, content: {
                LettersComponent(self, escape: [ .tab, .newline, .return, .doubleQuote ])
            })
        })
    }

}
