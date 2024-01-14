//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    final class Variable {
        
        let modifier: Modifier
        let specifier: KindMonadicMacroPlugin.Variable.Specifier
        let name: String
        let type: String
        let genericTypes: [String]
        let accessors: KindMonadicMacroPlugin.Variable.Accessors
        
        var isMutable: Bool {
            switch self.specifier {
            case .let: return false
            case .var:
                guard self.accessors.items.isEmpty == false else { return true }
                return self.accessors.items.contains(where: {
                    return $0.name == .set
                })
            }
        }
        var isStored: Bool {
            switch self.specifier {
            case .let: return true
            case .var:
                guard self.accessors.items.isEmpty == false else { return true }
                return self.accessors.items.contains(where: {
                    guard $0.name == .set else { return false }
                    return $0.flags.contains(.computed) == false
                })
            }
        }
        
        init(
            modifier: Modifier,
            specifier: KindMonadicMacroPlugin.Variable.Specifier,
            name: String,
            type: String,
            genericTypes: [String],
            accessors: KindMonadicMacroPlugin.Variable.Accessors
        ) {
            self.modifier = modifier
            self.specifier = specifier
            self.name = name
            self.type = type
            self.genericTypes = genericTypes
            self.accessors = accessors
        }
        
        init?(
            variableSyntax: VariableDeclSyntax,
            bindingSyntax: PatternBindingSyntax
        ) {
            self.modifier = .init(variableSyntax)
            
            guard let specifier = KindMonadicMacroPlugin.Variable.Specifier(variableSyntax) else {
                return nil
            }
            self.specifier = specifier
            
            guard let patternSyntax = bindingSyntax.pattern.as(IdentifierPatternSyntax.self) else {
                return nil
            }
            if let typeSyntax = bindingSyntax.typeAnnotation {
                self.name = patternSyntax.identifier.text
                self.type = typeSyntax.type.trimmed.description
                if let memberSyntax = typeSyntax.type.as(MemberTypeSyntax.self) {
                    if let genericArgumentClause = memberSyntax.genericArgumentClause {
                        self.genericTypes = genericArgumentClause.arguments.map({
                            $0.argument.trimmed.description
                        })
                    } else {
                        self.genericTypes = []
                    }
                } else {
                    self.genericTypes = []
                }
                self.accessors = .init(bindingSyntax)
            } else if let exprSyntax = bindingSyntax.initializer?.value.as(FunctionCallExprSyntax.self) {
                self.name = patternSyntax.identifier.text
                self.type = exprSyntax.trimmedDescription.description
                if let exprSyntax = exprSyntax.calledExpression.as(GenericSpecializationExprSyntax.self) {
                    self.genericTypes = exprSyntax.genericArgumentClause.arguments.map({
                        $0.argument.trimmed.description
                    })
                } else {
                    self.genericTypes = []
                }
                self.accessors = .init(bindingSyntax)
            } else {
                return nil
            }
        }
        
        func copy(name: String) -> Variable {
            return .init(
                modifier: self.modifier,
                specifier: self.specifier,
                name: name,
                type: self.type,
                genericTypes: self.genericTypes,
                accessors: self.accessors
            )
        }
        
    }
    
}
