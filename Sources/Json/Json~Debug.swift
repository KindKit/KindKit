//
//  KindKit
//

import Foundation

extension Json : CustomDebugStringConvertible {

    public var debugDescription: String {
        return self.dump()
    }
    
}

extension Json : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, data: "<Json")
        if let root = self.root as? NSArray {
            buff.append(inter: indent, data: root)
        } else if let root = self.root as? NSDictionary {
            buff.append(inter: indent, data: root)
        }
        buff.append(footer: indent, data: ">")
    }

}
