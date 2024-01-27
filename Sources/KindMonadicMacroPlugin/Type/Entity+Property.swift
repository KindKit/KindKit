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
        var setters: Bool
        var builder: String?
        var `default`: String?
        
        init(
            variable: Variable,
            setters: Bool = false,
            builder: String? = nil,
            `default`: String? = nil
        ) {
            self.variable = variable
            self.setters = setters
            self.builder = builder
            self.default = `default`
        }
        
        func copy(name: String) -> Property {
            return .init(
                variable: self.variable.copy(name: name),
                setters: self.setters,
                builder: self.builder,
                default: self.default
            )
        }
        
        func build(
            by entity: Entity,
            in context: some MacroExpansionContext
        ) -> MemberBlockItemListSyntax? {
            guard self.setters == true else {
                return nil
            }
            switch entity.target {
            case .struct:
                return .init(itemsBuilder: {
                    if let compileTime = self.variable.compileTime {
                        IfConfigDeclSyntax(clauses: .init(itemsBuilder: {
                            IfConfigClauseSyntax(
                                poundKeyword: .poundIfToken(),
                                condition: compileTime.condition,
                                elements: .init(
                                    MemberBlockItemListSyntax(itemsBuilder: {
                                        self.valueTypeFunction(by: entity)
                                    })
                                )
                            )
                        }))
                    } else {
                        self.valueTypeFunction(by: entity)
                    }
                })
            case .class, .protocol:
                guard self.variable.isMutable == true else {
                    return nil
                }
                return .init(itemsBuilder: {
                    if let compileTime = self.variable.compileTime {
                        IfConfigDeclSyntax(clauses: .init(itemsBuilder: {
                            IfConfigClauseSyntax(
                                poundKeyword: .poundIfToken(),
                                condition: compileTime.condition,
                                elements: .init(
                                    self.referenceTypeFunctions(by: entity)
                                )
                            )
                        }))
                    } else {
                        self.referenceTypeFunctions(by: entity)
                    }
                })
            }
        }
        
    }
    
}

fileprivate extension Entity.Property {
    
    func valueTypeFunction(
        by entity: Entity
    ) -> FunctionDeclSyntax {
        return .init(
            attributes: .init(itemsBuilder: {
                AttributeSyntax("@inlinable")
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
    }
    
    @MemberBlockItemListBuilder
    func referenceTypeFunctions(
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
    }
    
}
