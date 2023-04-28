//
//  KindKit
//

import Foundation

extension Dictionary : IDebug where Key : IDebug, Value : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "{")
        for item in self {
            buff.append(inter: indent, key: item.key, value: item.value)
        }
        buff.append(footer: indent, value: "}")
    }

}
