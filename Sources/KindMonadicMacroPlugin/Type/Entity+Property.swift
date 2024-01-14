//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    final class Property {
        
        let variable: Variable
        
        init(variable: Variable) {
            self.variable = variable
        }
        
        func copy(name: String) -> Property {
            return .init(
                variable: self.variable.copy(name: name)
            )
        }
        
        func build(
            by entity: Entity,
            in context: some MacroExpansionContext
        ) -> MemberBlockItemListSyntax? {
            switch entity.target {
            case .struct:
                return .init(itemsBuilder: {
                    FunctionDeclSyntax(
                        modifiers: self.variable.modifier.build(),
                        name: .identifier(self.variable.name),
                        signature: .init(
                            parameterClause: .init(parametersBuilder: {
                                FunctionParameterSyntax(
                                    firstName: .wildcardToken(),
                                    secondName: .identifier("value"),
                                    type: IdentifierTypeSyntax(name: .identifier(self.variable.type))
                                )
                            }),
                            returnClause: .init(
                                type: IdentifierTypeSyntax(name: .keyword(.Self))
                            )
                        ),
                        bodyBuilder: {
                            ReturnStmtSyntax(
                                expression: FunctionCallExprSyntax(
                                    callee: ExprSyntax(".init"),
                                    argumentList: {
                                        for variable in entity.variables {
                                            if variable.isStored == true {
                                                if variable.name == self.variable.name {
                                                    LabeledExprSyntax(
                                                        label: variable.name,
                                                        expression: DeclReferenceExprSyntax(baseName: .identifier("value"))
                                                    )
                                                } else {
                                                    LabeledExprSyntax(
                                                        label: variable.name,
                                                        expression: MemberAccessExprSyntax(
                                                            base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                                            name: .identifier(variable.name)
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                    }
                                )
                            )
                        }
                    )
                })
            case .class, .protocol:
                guard self.variable.isMutable == true else {
                    return nil
                }
                return .init(itemsBuilder: {
                    FunctionDeclSyntax(
                        attributes: .init(itemsBuilder: {
                            AttributeSyntax("@discardableResult")
                        }),
                        modifiers: self.variable.modifier.build(),
                        name: .identifier(self.variable.name),
                        signature: .init(
                            parameterClause: .init(parametersBuilder: {
                                FunctionParameterSyntax(
                                    firstName: .wildcardToken(),
                                    secondName: .identifier("value"),
                                    type: IdentifierTypeSyntax(name: .identifier(self.variable.type))
                                )
                            }),
                            returnClause: .init(
                                type: IdentifierTypeSyntax(name: .keyword(.Self))
                            )
                        ),
                        bodyBuilder: {
                            SequenceExprSyntax(elementsBuilder: {
                                MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                    name: .identifier(self.variable.name)
                                )
                                AssignmentExprSyntax()
                                DeclReferenceExprSyntax(baseName: .identifier("value"))
                            })
                            ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                        }
                    )
                    FunctionDeclSyntax(
                        attributes: .init(itemsBuilder: {
                            AttributeSyntax("@discardableResult")
                        }),
                        modifiers: self.variable.modifier.build(),
                        name: .identifier(self.variable.name),
                        signature: .init(
                            parameterClause: .init(parametersBuilder: {
                                FunctionParameterSyntax(
                                    firstName: .wildcardToken(),
                                    secondName: .identifier("value"),
                                    type: FunctionTypeSyntax(
                                        parameters: [],
                                        returnClause: ReturnClauseSyntax(
                                            type: IdentifierTypeSyntax(name: .identifier(self.variable.type))
                                        )
                                    )
                                )
                            }),
                            returnClause: .init(
                                type: IdentifierTypeSyntax(name: .keyword(.Self))
                            )
                        ),
                        bodyBuilder: {
                            SequenceExprSyntax(elementsBuilder: {
                                MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                    name: .identifier(self.variable.name)
                                )
                                AssignmentExprSyntax()
                                FunctionCallExprSyntax(
                                    callee: DeclReferenceExprSyntax(baseName: .identifier("value"))
                                )
                            })
                            ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                        }
                    )
                    FunctionDeclSyntax(
                        attributes: .init(itemsBuilder: {
                            AttributeSyntax("@discardableResult")
                        }),
                        modifiers: self.variable.modifier.build(),
                        name: .identifier(self.variable.name),
                        signature: .init(
                            parameterClause: .init(parametersBuilder: {
                                FunctionParameterSyntax(
                                    firstName: .wildcardToken(),
                                    secondName: .identifier("value"),
                                    type: FunctionTypeSyntax(
                                        parameters: .init(itemsBuilder: {
                                            TupleTypeElementSyntax(
                                                type: IdentifierTypeSyntax(name: .keyword(.Self))
                                            )
                                        }),
                                        returnClause: .init(
                                            type: IdentifierTypeSyntax(name: .identifier(self.variable.type))
                                        )
                                    )
                                )
                            }),
                            returnClause: .init(
                                type: IdentifierTypeSyntax(name: .keyword(.Self))
                            )
                        ),
                        bodyBuilder: {
                            SequenceExprSyntax(elementsBuilder: {
                                MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                    name: .identifier(self.variable.name)
                                )
                                AssignmentExprSyntax()
                                FunctionCallExprSyntax(
                                    callee: DeclReferenceExprSyntax(baseName: .identifier("value")),
                                    argumentList: {
                                        LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                                    }
                                )
                            })
                            ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                        }
                    )
                })
            }
        }
        
    }
    
}
