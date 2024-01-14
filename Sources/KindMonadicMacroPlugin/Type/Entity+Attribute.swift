//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    enum Attribute {
        
        case alias(String)
        case property
        case signal
        
        init?(_ syntax: AttributeListSyntax.Element) {
            guard let syntax = syntax.as(AttributeSyntax.self) else { return nil }
            self.init(syntax)
        }
        
        init?(_ syntax: AttributeSyntax) {
            guard let nameSyntax = syntax.attributeName.as(IdentifierTypeSyntax.self) else { return nil }
            switch nameSyntax.name.trimmed.text {
            case "KindMonadicProperty":
                if let argument = syntax.arguments?.as(LabeledExprListSyntax.self)?.first {
                    switch argument.label?.trimmed.text {
                    case "alias":
                        if let expression = argument.expression.as(StringLiteralExprSyntax.self) {
                            self = .alias(expression.segments.trimmedDescription)
                        } else {
                            self = .property
                        }
                    default:
                        self = .property
                    }
                } else {
                    self = .property
                }
            case "KindMonadicSignal":
                self = .signal
            default: 
                return nil
            }
        }
        
    }
    
}
