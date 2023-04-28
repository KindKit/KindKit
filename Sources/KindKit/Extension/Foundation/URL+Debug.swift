//
//  KindKit
//

import Foundation

extension URL : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent).append("\"\(self.absoluteString)\"")
    }

}

extension NSURL : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent)
        if let url = self.absoluteString {
            buff.append("\"\(url)\"")
        } else {
            buff.append("\"\(self.relativeString)\"")
        }
    }

}
