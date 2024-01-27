//
//  KindKit
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
        var result: String {
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
        let modifiers = self.variable.modifier.safe
        let fullParameters = self.parameters()
        let shortParameters: TupleTypeElementListSyntax = []
        FunctionDeclSyntax(
            attributes: .init(itemsBuilder: {
                if self.variable.modifier.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(self.variable.name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("regular"),
                        secondName: .identifier("closure"),
                        type: AttributedTypeSyntax(
                            specifiers: [],
                            attributes: .init(itemsBuilder: {
                                AttributeSyntax("@escaping")
                            }),
                            baseType: FunctionTypeSyntax(
                                parameters: self.parameters(
                                    target: nil,
                                    extra: shortParameters
                                ),
                                returnClause: .init(
                                    type: IdentifierTypeSyntax(name: .identifier(self.result))
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
                            name: .identifier("connect")
                        ),
                        argumentList: {
                            LabeledExprSyntax(
                                label: .identifier("regular"),
                                colon: .colonToken(),
                                expression: DeclReferenceExprSyntax(baseName: .identifier("closure"))
                            )
                        }
                    )
                })
                ReturnStmtSyntax(
                    expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                )
            }
        )
        if fullParameters.isEmpty == false {
            FunctionDeclSyntax(
                attributes: .init(itemsBuilder: {
                    if self.variable.modifier.isPublicSet {
                        AttributeSyntax("@inlinable")
                    }
                    AttributeSyntax("@discardableResult")
                }),
                modifiers: .init(itemsBuilder: {
                    self.variable.modifier
                }),
                name: .identifier(self.variable.name),
                signature: .init(
                    parameterClause: .init(parametersBuilder: {
                        FunctionParameterSyntax(
                            firstName: .identifier("regular"),
                            secondName: .identifier("closure"),
                            type: AttributedTypeSyntax(
                                specifiers: [],
                                attributes: .init(itemsBuilder: {
                                    AttributeSyntax("@escaping")
                                }),
                                baseType: FunctionTypeSyntax(
                                    parameters: self.parameters(
                                        target: nil,
                                        extra: fullParameters
                                    ),
                                    returnClause: .init(
                                        type: IdentifierTypeSyntax(name: .identifier(self.result))
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
                                name: .identifier("connect")
                            ),
                            argumentList: {
                                LabeledExprSyntax(
                                    label: .identifier("regular"),
                                    colon: .colonToken(),
                                    expression: DeclReferenceExprSyntax(baseName: .identifier("closure"))
                                )
                            }
                        )
                    })
                    ReturnStmtSyntax(
                        expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                    )
                }
            )
        }
        FunctionDeclSyntax(
            attributes: .init(itemsBuilder: {
                if self.variable.modifier.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(self.variable.name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("regular"),
                        secondName: .identifier("closure"),
                        type: AttributedTypeSyntax(
                            specifiers: [],
                            attributes: .init(itemsBuilder: {
                                AttributeSyntax("@escaping")
                            }),
                            baseType: FunctionTypeSyntax(
                                parameters: self.parameters(
                                    target: .init(name: .keyword(.Self)),
                                    extra: shortParameters
                                ),
                                returnClause: .init(
                                    type: IdentifierTypeSyntax(name: .identifier(self.result))
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
                            name: .identifier("connect")
                        ),
                        argumentList: {
                            LabeledExprSyntax(
                                label: .identifier("capture"),
                                colon: .colonToken(),
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        period: .periodToken(),
                                        name: .identifier("weak")
                                    ),
                                    argumentList: {
                                        LabeledExprSyntax(
                                            expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                                        )
                                    }
                                )
                            )
                            LabeledExprSyntax(
                                label: .identifier("regular"),
                                colon: .colonToken(),
                                expression: DeclReferenceExprSyntax(baseName: .identifier("closure"))
                            )
                        }
                    )
                })
                ReturnStmtSyntax(
                    expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                )
            }
        )
        if fullParameters.isEmpty == false {
            FunctionDeclSyntax(
                attributes: .init(itemsBuilder: {
                    if self.variable.modifier.isPublicSet {
                        AttributeSyntax("@inlinable")
                    }
                    AttributeSyntax("@discardableResult")
                }),
                modifiers: .init(itemsBuilder: {
                    self.variable.modifier
                }),
                name: .identifier(self.variable.name),
                signature: .init(
                    parameterClause: .init(parametersBuilder: {
                        FunctionParameterSyntax(
                            firstName: .identifier("regular"),
                            secondName: .identifier("closure"),
                            type: AttributedTypeSyntax(
                                specifiers: [],
                                attributes: .init(itemsBuilder: {
                                    AttributeSyntax("@escaping")
                                }),
                                baseType: FunctionTypeSyntax(
                                    parameters: self.parameters(
                                        target: .init(name: .keyword(.Self)),
                                        extra: fullParameters
                                    ),
                                    returnClause: .init(
                                        type: IdentifierTypeSyntax(name: .identifier(self.result))
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
                                name: .identifier("connect")
                            ),
                            argumentList: {
                                LabeledExprSyntax(
                                    label: .identifier("capture"),
                                    colon: .colonToken(),
                                    expression: FunctionCallExprSyntax(
                                        callee: MemberAccessExprSyntax(
                                            period: .periodToken(),
                                            name: .identifier("weak")
                                        ),
                                        argumentList: {
                                            LabeledExprSyntax(
                                                expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                                            )
                                        }
                                    )
                                )
                                LabeledExprSyntax(
                                    label: .identifier("regular"),
                                    colon: .colonToken(),
                                    expression: DeclReferenceExprSyntax(baseName: .identifier("closure"))
                                )
                            }
                        )
                    })
                    ReturnStmtSyntax(
                        expression: DeclReferenceExprSyntax(baseName: .keyword(.self))
                    )
                }
            )
        }
        FunctionDeclSyntax(
            attributes: .init(itemsBuilder: {
                if self.variable.modifier.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(self.variable.name),
            genericParameterClause: .init(parameters: .init(itemsBuilder: {
                .init(
                    name: .identifier("Target")
                )
            })),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("target"),
                        type: IdentifierTypeSyntax(name: .identifier("Target"))
                    )
                    FunctionParameterSyntax(
                        firstName: .identifier("regular"),
                        secondName: .identifier("closure"),
                        type: AttributedTypeSyntax(
                            specifiers: [],
                            attributes: .init(itemsBuilder: {
                                AttributeSyntax("@escaping")
                            }),
                            baseType: FunctionTypeSyntax(
                                parameters: self.parameters(
                                    target: .init(name: .identifier("Target")),
                                    extra: shortParameters
                                ),
                                returnClause: .init(
                                    type: IdentifierTypeSyntax(name: .identifier(self.result))
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
                            leftType: IdentifierTypeSyntax(name: .identifier("Target")),
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
                            name: .identifier("connect")
                        ),
                        argumentList: {
                            LabeledExprSyntax(
                                label: .identifier("capture"),
                                colon: .colonToken(),
                                expression: FunctionCallExprSyntax(
                                    callee: MemberAccessExprSyntax(
                                        period: .periodToken(),
                                        name: .identifier("weak")
                                    ),
                                    argumentList: {
                                        LabeledExprSyntax(
                                            expression: DeclReferenceExprSyntax(baseName: .identifier("target"))
                                        )
                                    }
                                )
                            )
                            LabeledExprSyntax(
                                label: .identifier("regular"),
                                colon: .colonToken(),
                                expression: DeclReferenceExprSyntax(baseName: .identifier("closure"))
                            )
                        }
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
        if fullParameters.isEmpty == false {
            FunctionDeclSyntax(
                attributes: .init(itemsBuilder: {
                    if self.variable.modifier.isPublicSet {
                        AttributeSyntax("@inlinable")
                    }
                    AttributeSyntax("@discardableResult")
                }),
                modifiers: .init(itemsBuilder: {
                    self.variable.modifier
                }),
                name: .identifier(self.variable.name),
                genericParameterClause: .init(parameters: .init(itemsBuilder: {
                    .init(
                        name: .identifier("Target")
                    )
                })),
                signature: .init(
                    parameterClause: .init(parametersBuilder: {
                        FunctionParameterSyntax(
                            firstName: .identifier("target"),
                            type: IdentifierTypeSyntax(name: .identifier("Target"))
                        )
                        FunctionParameterSyntax(
                            firstName: .identifier("regular"),
                            secondName: .identifier("closure"),
                            type: AttributedTypeSyntax(
                                specifiers: [],
                                attributes: .init(itemsBuilder: {
                                    AttributeSyntax("@escaping")
                                }),
                                baseType: FunctionTypeSyntax(
                                    parameters: self.parameters(
                                        target: .init(name: .identifier("Target")),
                                        extra: fullParameters
                                    ),
                                    returnClause: .init(
                                        type: IdentifierTypeSyntax(name: .identifier(self.result))
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
                                leftType: IdentifierTypeSyntax(name: .identifier("Target")),
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
                                name: .identifier("connect")
                            ),
                            argumentList: {
                                LabeledExprSyntax(
                                    label: .identifier("capture"),
                                    colon: .colonToken(),
                                    expression: FunctionCallExprSyntax(
                                        callee: MemberAccessExprSyntax(
                                            period: .periodToken(),
                                            name: .identifier("weak")
                                        ),
                                        argumentList: {
                                            LabeledExprSyntax(
                                                expression: DeclReferenceExprSyntax(baseName: .identifier("target"))
                                            )
                                        }
                                    )
                                )
                                LabeledExprSyntax(
                                    label: .identifier("regular"),
                                    colon: .colonToken(),
                                    expression: DeclReferenceExprSyntax(baseName: .identifier("closure"))
                                )
                            }
                        )
                    })
                    ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                }
            )
        }
        FunctionDeclSyntax(
            attributes: .init(itemsBuilder: {
                if self.variable.modifier.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(self.variable.name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("disconnect"),
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
                            name: .identifier("disconnect")
                        ),
                        argumentList: {
                            LabeledExprSyntax(
                                expression: DeclReferenceExprSyntax(baseName: .identifier("target"))
                            )
                        }
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
    }
    
    func parameters() -> TupleTypeElementListSyntax {
        return TupleTypeElementListSyntax(itemsBuilder: {
            for argument in self.argumentTypes.filter({ $0 != "Void" }) {
                TupleTypeElementSyntax(
                    type: IdentifierTypeSyntax(name: .identifier(argument))
                )
            }
        })
    }
    
    func parameters(
        target: IdentifierTypeSyntax?,
        extra: TupleTypeElementListSyntax
    ) -> TupleTypeElementListSyntax {
        return TupleTypeElementListSyntax(itemsBuilder: {
            if let target = target {
                TupleTypeElementSyntax(
                    type: target
                )
            }
            extra
        })
    }
    
}
