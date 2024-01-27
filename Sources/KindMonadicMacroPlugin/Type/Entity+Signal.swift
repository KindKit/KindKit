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
            if let compileTime = self.variable.compileTime {
                return .init(itemsBuilder: {
                    IfConfigDeclSyntax(clauses: .init(itemsBuilder: {
                        IfConfigClauseSyntax(
                            poundKeyword: .poundIfToken(),
                            condition: compileTime.condition,
                            elements: .init(
                                self.functions(by: entity)
                            )
                        )
                    }))
                })
            } else {
                return self.functions(by: entity)
            }
        }
        
    }
    
}

fileprivate extension Entity.Signal {
    
    @MemberBlockItemListBuilder
    func functions(
        by entity: Entity
    ) -> MemberBlockItemListSyntax {
        FunctionDeclSyntax(
            attributes: .init(itemsBuilder: {
                AttributeSyntax("@inlinable")
                AttributeSyntax("@discardableResult")
            }),
            modifiers: .init(itemsBuilder: {
                if let modifier = self.variable.modifier {
                    switch modifier {
                    case .internal:
                        .init(name: .keyword(.internal))
                    case .fileprivate:
                        .init(name: .keyword(.fileprivate))
                    case .private:
                        .init(name: .keyword(.private))
                    case .public:
                        .init(name: .keyword(.public))
                    }
                }
            }),
            name: .identifier(self.variable.name),
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
                            name: .identifier("add")
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
                AttributeSyntax("@inlinable")
                AttributeSyntax("@discardableResult")
            }),
            modifiers: .init(itemsBuilder: {
                if let modifier = self.variable.modifier {
                    switch modifier {
                    case .internal:
                        .init(name: .keyword(.internal))
                    case .fileprivate:
                        .init(name: .keyword(.fileprivate))
                    case .private:
                        .init(name: .keyword(.private))
                    case .public:
                        .init(name: .keyword(.public))
                    }
                }
            }),
            name: .identifier(self.variable.name),
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
                                    target: .init(name: .keyword(.Self))
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
                            name: .identifier("add")
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
                AttributeSyntax("@inlinable")
                AttributeSyntax("@discardableResult")
            }),
            modifiers: .init(itemsBuilder: {
                if let modifier = self.variable.modifier {
                    switch modifier {
                    case .internal:
                        .init(name: .keyword(.internal))
                    case .fileprivate:
                        .init(name: .keyword(.fileprivate))
                    case .private:
                        .init(name: .keyword(.private))
                    case .public:
                        .init(name: .keyword(.public))
                    }
                }
            }),
            name: .identifier(self.variable.name),
            genericParameterClause: .init(parameters: .init(itemsBuilder: {
                .init(
                    name: .identifier("TargetType")
                )
            })),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .wildcardToken(),
                        secondName: .identifier("target"),
                        type: IdentifierTypeSyntax(name: .identifier("TargetType"))
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
                                    target: .init(name: .identifier("TargetType"))
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
                            leftType: IdentifierTypeSyntax(name: .identifier("TargetType")),
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
                            name: .identifier("add")
                        ),
                        argumentList: {
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("target")))
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("closure")))
                        }
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
        FunctionDeclSyntax(
            attributes: .init(itemsBuilder: {
                AttributeSyntax("@inlinable")
                AttributeSyntax("@discardableResult")
            }),
            modifiers: .init(itemsBuilder: {
                if let modifier = self.variable.modifier {
                    switch modifier {
                    case .internal:
                        .init(name: .keyword(.internal))
                    case .fileprivate:
                        .init(name: .keyword(.fileprivate))
                    case .private:
                        .init(name: .keyword(.private))
                    case .public:
                        .init(name: .keyword(.public))
                    }
                }
            }),
            name: .identifier(self.variable.name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("remove"),
                        secondName: .identifier("target"),
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
                            name: .identifier("remove")
                        ),
                        argumentList: {
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .identifier("target")))
                        }
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
    }
    
    func parameters(target: IdentifierTypeSyntax? = nil) -> TupleTypeElementListSyntax {
        return TupleTypeElementListSyntax(itemsBuilder: {
            if let target = target {
                TupleTypeElementSyntax(
                    type: target
                )
            }
            for argumentType in self.argumentTypes.filter({ $0 != "Void" }) {
                TupleTypeElementSyntax(
                    type: IdentifierTypeSyntax(name: .identifier(argumentType))
                )
            }
        })
    }
    
}
