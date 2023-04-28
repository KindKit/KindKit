//
//  KindKit
//

import Foundation

extension Array : IDebug where Element : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "[")
        for item in self {
            buff.append(inter: indent, value: item)
        }
        buff.append(footer: indent, value: "]")
    }

}
