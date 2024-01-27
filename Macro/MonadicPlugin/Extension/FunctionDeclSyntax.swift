//
//  KindKit
//

import SwiftSyntax

extension FunctionDeclSyntax {
    
    static func setterWithValue(
        modifiers: DeclModifierListSyntax,
        name: String,
        type: String
    ) -> Self {
        return .init(
            attributes: .init(itemsBuilder: {
                if modifiers.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .wildcardToken(),
                        secondName: .identifier("value"),
                        type: IdentifierTypeSyntax(name: .identifier(type))
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
                        name: .identifier(name)
                    )
                    AssignmentExprSyntax()
                    DeclReferenceExprSyntax(baseName: .identifier("value"))
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
    }
    
    static func setterWithClosure(
        modifiers: DeclModifierListSyntax,
        name: String,
        type: String
    ) -> Self {
        return .init(
            attributes: .init(itemsBuilder: {
                if modifiers.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("on"),
                        type: FunctionTypeSyntax(
                            parameters: [],
                            returnClause: ReturnClauseSyntax(
                                type: IdentifierTypeSyntax(name: .identifier(type))
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
                        name: .identifier(name)
                    )
                    AssignmentExprSyntax()
                    FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: .identifier("on"))
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
    }
    
    static func setterWithClosureSelf(
        modifiers: DeclModifierListSyntax,
        name: String,
        type: String
    ) -> Self {
        return .init(
            attributes: .init(itemsBuilder: {
                if modifiers.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: .identifier("on"),
                        type: FunctionTypeSyntax(
                            parameters: .init(itemsBuilder: {
                                TupleTypeElementSyntax(
                                    type: IdentifierTypeSyntax(name: .keyword(.Self))
                                )
                            }),
                            returnClause: .init(
                                type: IdentifierTypeSyntax(name: .identifier(type))
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
                        name: .identifier(name)
                    )
                    AssignmentExprSyntax()
                    FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: .identifier("on")),
                        argumentList: {
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                        }
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
    }
    
    static func setterWithBuilder(
        modifiers: DeclModifierListSyntax,
        name: String,
        type: String,
        builder: String
    ) -> Self {
        return .init(
            attributes: .init(itemsBuilder: {
                if modifiers.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
                AttributeSyntax("@discardableResult")
            }),
            modifiers: modifiers,
            name: .identifier(name),
            signature: .init(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        attributes: [
                            .init(AttributeSyntax(
                                attributeName: IdentifierTypeSyntax(name: .identifier(builder))
                            ))
                        ],
                        firstName: .identifier("builder"),
                        type: FunctionTypeSyntax(
                            parameters: [],
                            returnClause: ReturnClauseSyntax(
                                type: IdentifierTypeSyntax(name: .identifier(type))
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
                        name: .identifier(name)
                    )
                    AssignmentExprSyntax()
                    FunctionCallExprSyntax(
                        callee: DeclReferenceExprSyntax(baseName: .identifier("builder"))
                    )
                })
                ReturnStmtSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
            }
        )
    }
    
}
