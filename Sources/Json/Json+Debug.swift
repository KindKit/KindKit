//
//  KindKitJson
//

import Foundation
import KindKitCore



#if DEBUG

extension Json : IDebug {

    public func debugString(_ buffer: inout String, _ headerIndent: Int, _ indent: Int, _ footerIndent: Int) {
        if self.isArray == true {
            let array = try! self.array()
            array.debugString(&buffer, headerIndent, indent, footerIndent)
        } else if self.isDictionary == true {
            let dictionary = try! self.dictionary()
            dictionary.debugString(&buffer, headerIndent, indent, footerIndent)
        } else {
            if headerIndent > 0 {
                buffer.append(String(repeating: "\t", count: headerIndent))
            }
            buffer.append("<Json>")
        }
    }

}

#endif
