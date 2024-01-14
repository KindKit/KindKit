//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

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
        
        func build() -> TokenSyntax {
            switch self {
            case .let: return .keyword(.let)
            case .var: return .keyword(.var)
            }
        }
        
    }
    
}
