//
//  KindKit
//

import Foundation
import KindString

extension Data : DebugTrait {
    
    public func buildInfo() -> Info {
        if let json = try? JSONSerialization.jsonObject(with: self) as? DebugTrait {
            return AnyInfo(json)
        } else if let string = String(data: self, encoding: .utf8) {
            return StringInfo({
                QuoteComponent(.double, content: {
                    LettersComponent(string, escape: [ .tab, .newline, .return, .doubleQuote ])
                })
            })
        }
        return StringInfo("\(self.count) bytes")
    }

}
