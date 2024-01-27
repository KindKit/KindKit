//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    enum Attribute {
        
        case property
        case propertyAlias(String)
        case propertyBuilder(String)
        case propertyDefault(String)
        case signal
        
        init?(_ syntax: AttributeListSyntax.Element) {
            guard let syntax = syntax.as(AttributeSyntax.self) else { return nil }
            self.init(syntax)
        }
        
        init?(_ syntax: AttributeSyntax) {
            guard let nameSyntax = syntax.attributeName.as(IdentifierTypeSyntax.self) else { 
                return nil
            }
            switch nameSyntax.name.trimmed.text {
            case "KindMonadicProperty":
                if let argument = syntax.arguments?.as(LabeledExprListSyntax.self)?.first {
                    switch argument.label?.trimmed.text {
                    case "alias":
                        if let expression = argument.expression.as(StringLiteralExprSyntax.self) {
                            self = .propertyAlias(expression.segments.trimmedDescription)
                        } else {
                            return nil
                        }
                    case "builder":
                        guard let memberAccessExpression = argument.expression.as(MemberAccessExprSyntax.self) else {
                            return nil
                        }
                        guard memberAccessExpression.declName.baseName.tokenKind == .keyword(.self) else {
                            return nil
                        }
                        guard let nameExpression = memberAccessExpression.base?.as(DeclReferenceExprSyntax.self) else {
                            return nil
                        }
                        self = .propertyBuilder(nameExpression.trimmedDescription)
                    case "default":
                        guard let memberAccessExpression = argument.expression.as(MemberAccessExprSyntax.self) else {
                            return nil
                        }
                        guard memberAccessExpression.declName.baseName.tokenKind == .keyword(.self) else {
                            return nil
                        }
                        guard let nameExpression = memberAccessExpression.base?.as(DeclReferenceExprSyntax.self) else {
                            return nil
                        }
                        self = .propertyDefault(nameExpression.trimmedDescription)
                    default:
                        return nil
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
