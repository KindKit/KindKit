//
//  KindKit
//

import Foundation

public extension Json.Error {

    enum Coding : Swift.Error {
        
        case access(Json.Path)
        case cast(Json.Path)
        
    }
        
}

extension Json.Error.Coding : IDebug {
    
    public func dump(_ buff: StringBuilder, _ indent: Debug.Indent) {
        buff.append(header: indent, value: "Json.Error.Coding")
        switch self {
        case .access(let path): buff.append(inter: indent, key: "Access", value: path.string)
        case .cast(let path): buff.append(inter: indent, key: "Cast", value: path.string)
        }
    }
    
}
