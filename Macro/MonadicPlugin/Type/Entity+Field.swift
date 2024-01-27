//
//  KindKit
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    final class Field {
        
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
        
        func copy(name: String) -> Field {
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

fileprivate extension Entity.Field {
    
    func valueTypeFunction(
        by entity: Entity
    ) -> FunctionDeclSyntax {
        let modifiers = self.variable.modifier.safe
        
        return .init(
            attributes: .init(itemsBuilder: {
                if modifiers.isPublicSet {
                    AttributeSyntax("@inlinable")
                }
            }),
            modifiers: modifiers,
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
                            let trimCharacterSet = CharacterSet(charactersIn: "`")
                            for variable in entity.variables {
                                if variable.isStored == true {
                                    let lable = variable.name.trimmingCharacters(in: trimCharacterSet)
                                    if variable.name == self.variable.name {
                                        LabeledExprSyntax(
                                            label: lable,
                                            expression: DeclReferenceExprSyntax(baseName: .identifier("value"))
                                        )
                                    } else {
                                        LabeledExprSyntax(
                                            label: lable,
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
        let modifiers = self.variable.modifier.safe
        
        FunctionDeclSyntax.setterWithValue(
            modifiers: modifiers,
            name: self.variable.name,
            type: self.variable.type
        )
        FunctionDeclSyntax.setterWithClosure(
            modifiers: modifiers,
            name: self.variable.name,
            type: self.variable.type
        )
        FunctionDeclSyntax.setterWithClosureSelf(
            modifiers: modifiers,
            name: self.variable.name,
            type: self.variable.type
        )
        if let builder = self.builder {
            FunctionDeclSyntax.setterWithBuilder(
                modifiers: modifiers,
                name: self.variable.name,
                type: self.variable.type,
                builder: builder
            )
        }
    }
    
}
