//
//  KindKit
//

import Foundation

extension String : IDebug {
    
    public func debugInfo() -> Debug.Info {
        return .string("\"\(self.kk_escape([ .tab, .newline, .return, .doubleQuote ]))\"")
    }

}
