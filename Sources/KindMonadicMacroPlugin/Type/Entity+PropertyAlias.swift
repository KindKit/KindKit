//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    final class PropertyAlias {
        
        let alias: String
        let variable: Variable
        
        init(
            alias: String,
            variable: Variable
        ) {
            self.alias = alias
            self.variable = variable
        }
        
        func build(
            by entity: Entity,
            in context: some MacroExpansionContext
        ) -> MemberBlockItemListSyntax? {
            return .init(itemsBuilder: {
                if let compileTime = self.variable.compileTime {
                    IfConfigDeclSyntax(clauses: .init(itemsBuilder: {
                        IfConfigClauseSyntax(
                            poundKeyword: .poundIfToken(),
                            condition: compileTime.condition,
                            elements: .init(
                                MemberBlockItemListSyntax(itemsBuilder: {
                                    self.variable(by: entity)
                                })
                            )
                        )
                    }))
                } else {
                    self.variable(by: entity)
                }
            })
        }
        
    }
    
}

fileprivate extension Entity.PropertyAlias {
    
    func variable(
        by entity: Entity
    ) -> VariableDeclSyntax {
        return .init(
            bindingSpecifier: .keyword(.var),
            bindingsBuilder: {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier(self.alias)),
                    typeAnnotation: TypeAnnotationSyntax(type: IdentifierTypeSyntax(name: .identifier(self.variable.type))),
                    accessorBlock: AccessorBlockSyntax(accessors: .accessors(.init(itemsBuilder: {
                        if self.variable.isMutable == true && self.variable.isStored == true {
                            AccessorDeclSyntax(
                                accessorSpecifier: .keyword(.set),
                                bodyBuilder: {
                                    SequenceExprSyntax(elementsBuilder: {
                                        MemberAccessExprSyntax(
                                            base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                            name: .identifier(self.variable.name)
                                        )
                                        AssignmentExprSyntax()
                                        DeclReferenceExprSyntax(baseName: .identifier("newValue"))
                                    })
                                }
                            )
                        }
                        AccessorDeclSyntax(
                            accessorSpecifier: .keyword(.get),
                            bodyBuilder: {
                                MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                    name: .identifier(self.variable.name)
                                )
                            }
                        )
                    })))
                )
            }
        )
    }
    
}
