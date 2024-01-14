//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    final class Signal {
        
        let variable: Variable
        var onName: String {
            return "on\(self.variable.name.capitalized)"
        }
        var unName: String {
            return "un\(self.variable.name.capitalized)"
        }
        var isValid: Bool {
            return self.variable.genericTypes.isEmpty == false
        }
        var resultType: String {
            return self.variable.genericTypes[0]
        }
        var argumentTypes: [String] {
            return Array(self.variable.genericTypes[1..<self.variable.genericTypes.count])
        }
        
        init(
            variable: Variable
        ) {
            self.variable = variable
        }
        
        func copy(name: String) -> Signal {
            return .init(
                variable: self.variable.copy(name: name)
            )
        }
        
        func build(
            by entity: Entity,
            in context: some MacroExpansionContext
        ) -> MemberBlockItemListSyntax? {
            guard self.isValid == true else {
                return nil
            }
            return .init(itemsBuilder: {
                FunctionDeclSyntax(
                    attributes: .init(itemsBuilder: {
                        AttributeSyntax("@discardableResult")
                    }),
                    modifiers: self.variable.modifier.build(),
                    name: .identifier(self.onName),
                    signature: .init(
                        parameterClause: .init(parametersBuilder: {
                            FunctionParameterSyntax(
                                firstName: .wildcardToken(),
                                secondName: .identifier("closure"),
                                type: AttributedTypeSyntax(
                                    attributes: .init(itemsBuilder: {
                                        AttributeSyntax("@escaping")
                                    }),
                                    baseType: FunctionTypeSyntax(
                                        parameters: self.parameters(),
                                        returnClause: .init(
                                            type: IdentifierTypeSyntax(name: .identifier(self.resultType))
                                        )
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
                            FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                        name: .identifier(self.variable.name)
                                    ),
                                    name: .identifier("on")
                                ),
                                argumentList: {
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("closure")))
                                }
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
                    name: .identifier(self.onName),
                    signature: .init(
                        parameterClause: .init(parametersBuilder: {
                            FunctionParameterSyntax(
                                firstName: .wildcardToken(),
                                secondName: .identifier("closure"),
                                type: AttributedTypeSyntax(
                                    attributes: .init(itemsBuilder: {
                                        AttributeSyntax("@escaping")
                                    }),
                                    baseType: FunctionTypeSyntax(
                                        parameters: self.parameters(
                                            sender: .init(name: .keyword(.Self))
                                        ),
                                        returnClause: .init(
                                            type: IdentifierTypeSyntax(name: .identifier(self.resultType))
                                        )
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
                            FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                        name: .identifier(self.variable.name)
                                    ),
                                    name: .identifier("on")
                                ),
                                argumentList: {
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("closure")))
                                }
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
                    name: .identifier(self.onName),
                    genericParameterClause: .init(parameters: .init(itemsBuilder: {
                        .init(
                            name: .identifier("Sender")
                        )
                    })),
                    signature: .init(
                        parameterClause: .init(parametersBuilder: {
                            FunctionParameterSyntax(
                                firstName: .wildcardToken(),
                                secondName: .identifier("sender"),
                                type: IdentifierTypeSyntax(name: .identifier("Sender"))
                            )
                            FunctionParameterSyntax(
                                firstName: .wildcardToken(),
                                secondName: .identifier("closure"),
                                type: AttributedTypeSyntax(
                                    attributes: .init(itemsBuilder: {
                                        AttributeSyntax("@escaping")
                                    }),
                                    baseType: FunctionTypeSyntax(
                                        parameters: self.parameters(
                                            sender: .init(name: .identifier("Sender"))
                                        ),
                                        returnClause: .init(
                                            type: IdentifierTypeSyntax(name: .identifier(self.resultType))
                                        )
                                    )
                                )
                            )
                        }),
                        returnClause: .init(
                            type: IdentifierTypeSyntax(name: .keyword(.Self))
                        )
                    ),
                    genericWhereClause: .init(requirementsBuilder: {
                        .init(
                            requirement: .conformanceRequirement(
                                .init(
                                    leftType: IdentifierTypeSyntax(name: .identifier("Sender")),
                                    rightType: IdentifierTypeSyntax(name: .identifier("AnyObject"))
                                )
                            )
                        )
                    }),
                    bodyBuilder: {
                        SequenceExprSyntax(elementsBuilder: {
                            FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                        name: .identifier(self.variable.name)
                                    ),
                                    name: .identifier("on")
                                ),
                                argumentList: {
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("sender")))
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("closure")))
                                }
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
                    name: .identifier(self.unName),
                    signature: .init(
                        parameterClause: .init(parametersBuilder: {
                            FunctionParameterSyntax(
                                firstName: .wildcardToken(),
                                secondName: .identifier("sender"),
                                type: IdentifierTypeSyntax(name: .identifier("AnyObject"))
                            )
                        }),
                        returnClause: .init(
                            type: IdentifierTypeSyntax(name: .keyword(.Self))
                        )
                    ),
                    bodyBuilder: {
                        SequenceExprSyntax(elementsBuilder: {
                            FunctionCallExprSyntax(
                                callee: MemberAccessExprSyntax(
                                    base: MemberAccessExprSyntax(
                                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                        name: .identifier(self.variable.name)
                                    ),
                                    name: .identifier("un")
                                ),
                                argumentList: {
                                    LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("sender")))
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

fileprivate extension Entity.Signal {
    
    func parameters(sender: IdentifierTypeSyntax? = nil) -> TupleTypeElementListSyntax {
        return TupleTypeElementListSyntax(itemsBuilder: {
            if let sender = sender {
                TupleTypeElementSyntax(
                    type: sender
                )
            }
            for argumentType in self.argumentTypes {
                TupleTypeElementSyntax(
                    type: IdentifierTypeSyntax(name: .identifier(argumentType))
                )
            }
        })
    }
    
}
