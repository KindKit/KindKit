//
//  KindKit
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    enum Attribute {
        
        case field
        case fieldAlias(String)
        case fieldBuilder(String)
        case fieldDefault(String)
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
            case "MonadicField":
                if let argument = syntax.arguments?.as(LabeledExprListSyntax.self)?.first {
                    switch argument.label?.trimmed.text {
                    case "alias":
                        if let expression = argument.expression.as(StringLiteralExprSyntax.self) {
                            self = .fieldAlias(expression.segments.trimmedDescription)
                        } else {
                            return nil
                        }
                    case "builder":
                        if let nameExpression = argument.expression.as(DeclReferenceExprSyntax.self) {
                            self = .fieldBuilder(nameExpression.trimmedDescription)
                        } else if let memberAccessExpression = argument.expression.as(MemberAccessExprSyntax.self) {
                            guard memberAccessExpression.declName.baseName.tokenKind == .keyword(.self) else {
                                return nil
                            }
                            guard let nameExpression = memberAccessExpression.base?.as(DeclReferenceExprSyntax.self) else {
                                return nil
                            }
                            self = .fieldBuilder(nameExpression.trimmedDescription)
                        } else {
                            return nil
                        }
                    case "default":
                        if let nameExpression = argument.expression.as(DeclReferenceExprSyntax.self) {
                            self = .fieldDefault(nameExpression.trimmedDescription)
                        } else if let memberAccessExpression = argument.expression.as(MemberAccessExprSyntax.self) {
                            guard memberAccessExpression.declName.baseName.tokenKind == .keyword(.self) else {
                                return nil
                            }
                            guard let nameExpression = memberAccessExpression.base?.as(DeclReferenceExprSyntax.self) else {
                                return nil
                            }
                            self = .fieldDefault(nameExpression.trimmedDescription)
                        } else {
                            return nil
                        }
                    default:
                        return nil
                    }
                } else {
                    self = .field
                }
            case "MonadicSignal":
                self = .signal
            default: 
                return nil
            }
        }
        
    }
    
}
