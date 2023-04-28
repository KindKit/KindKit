//
//  KindKit
//

import Foundation

extension Result : IDebug where Success : IDebug, Failure : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Result")
        switch self {
        case .success(let value): buff.append(inter: indent, key: "Success", value: value)
        case .failure(let error): buff.append(inter: indent, key: "Failure", value: error)
        }
    }
    
}
