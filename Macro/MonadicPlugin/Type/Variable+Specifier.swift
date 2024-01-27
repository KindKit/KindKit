//
//  KindKit
//

import SwiftSyntax

extension Variable {
    
    enum Specifier {
        
        case `let`
        case `var`
        
        init?(_ syntax: VariableDeclSyntax) {
            switch syntax.bindingSpecifier.text {
            case "let": self = .let
            case "var": self = .var
            default: return nil
            }
        }
        
    }
    
}
