//
//  KindKit
//

import Foundation

extension Data : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\(self.count) bytes")
    }

}
