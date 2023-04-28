//
//  KindKit
//

import Foundation

extension String : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\"\(self.kk_escape(.doubleQuote))\"")
    }

}
