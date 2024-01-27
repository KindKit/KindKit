//
//  KindKit
//

import SwiftSyntax

extension Variable.Accessors.Item {
    
    enum Name {
        
        case `set`
        case `get`
        
        init?(_ syntax: TokenSyntax) {
            switch syntax.tokenKind {
            case .keyword(let keyword):
                switch keyword {
                case .set: self = .set
                case .get: self = .get
                default: return nil
                }
            default: return nil
            }
        }
                
    }
    
}
