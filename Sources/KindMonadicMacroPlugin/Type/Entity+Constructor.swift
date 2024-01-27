//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity {
    
    final class Constructor {
        
        let compileTime: CompileTimeCondition?
        let modifier: Modifier?
        let isOptional: Bool
        let parameters: [Parameter]
        
        init?(
            compileTime: CompileTimeCondition?,
            syntax: InitializerDeclSyntax
        ) {
            guard Self.isConvenience(syntax.modifiers) == false else {
                return nil
            }
            self.compileTime = compileTime
            self.modifier = .init(syntax.modifiers)
            self.isOptional = syntax.optionalMark != nil
            self.parameters = syntax.signature.parameterClause.parameters.map(Parameter.init)
        }
        
        func build(
            by entity: Entity,
            in context: some MacroExpansionContext
        ) -> MemberBlockItemListSyntax? {
            guard entity.properties.count > 0 else { return nil }
            let variants = self._variants(by: entity, in: context)
            return MemberBlockItemListSyntax(itemsBuilder: {
                if let compileTime = self.compileTime {
                    IfConfigDeclSyntax(clauses: .init(itemsBuilder: {
                        IfConfigClauseSyntax(
                            poundKeyword: .poundIfToken(),
                            condition: compileTime.condition,
                            elements: .init(
                                MemberBlockItemListSyntax(itemsBuilder: {
                                    for variants in variants {
                                        self._build(by: entity, in: context, variants: variants)
                                    }
                                })
                            )
                        )
                    }))
                } else {
                    for variants in variants {
                        self._build(by: entity, in: context, variants: variants)
                    }
                    
                }
            })
        }
        
    }
    
}

fileprivate extension Entity.Constructor {
    
    enum Variant {
        
        case origin(Parameter, Entity.Variable)
        case builder(Parameter, Entity.Variable, String)
        case `default`(Parameter, Entity.Variable, String)
        
        var origin: Variant {
            switch self {
            case .origin(let parameter, let variable):
                return .origin(parameter, variable)
            case .builder(let parameter, let variable, _):
                return .origin(parameter, variable)
            case .default(let parameter, let variable, _):
                return .origin(parameter, variable)
            }
        }
        
    }
    
}

fileprivate extension Entity.Constructor {
    
    static func isConvenience(_ syntax: DeclModifierListSyntax) -> Bool {
        for modifier in syntax {
            if modifier.name.tokenKind == .keyword(.convenience) {
                return true
            }
        }
        return false
    }
    
}

fileprivate extension Entity.Constructor {
    
    func _variants(
        by entity: Entity,
        in context: some MacroExpansionContext
    ) -> [[Variant]] {
        let possibles = self.parameters.compactMap({ parameter -> [Variant]? in
            guard let property = entity.property(name: parameter.name ?? parameter.label) else {
                return nil
            }
            var variants: [Variant] = []
            if let builder = property.builder {
                variants.append(.builder(parameter, property.variable, builder))
            }
            if let `default` = property.default {
                variants.append(.default(parameter, property.variable, `default`))
            }
            guard variants.isEmpty == false else {
                return nil
            }
            return variants
        })
        var result: [[Variant]] = []
        let startIndex = possibles.startIndex
        let endIndex = possibles.endIndex
        var currIndex = possibles.startIndex
        while currIndex < endIndex {
            let nextIndex = possibles.index(after: currIndex)
            for possible in possibles[currIndex] {
                var trailings: [Variant] = []
                trailings.append(possible)
                if nextIndex < endIndex {
                    for index in nextIndex ..< endIndex {
                        let variant = possibles[index][0]
                        trailings.append(variant.origin)
                    }
                }
                self._variants(possibles, [], startIndex ..< currIndex, trailings, &result)
            }
            currIndex = nextIndex
        }
        return result
    }
    
    func _variants(
        _ possibles: [[Variant]],
        _ leadings: [Variant],
        _ range: Range< Int >,
        _ trailings: [Variant],
        _ buffer: inout [[Variant]]
    ) {
        if range.isEmpty == false {
            var currIndex = range.lowerBound
            while currIndex < range.upperBound {
                let nextIndex = possibles.index(after: currIndex)
                do {
                    let possible = possibles[range.lowerBound][0]
                    self._variants(possibles, leadings + [ possible.origin ], nextIndex ..< range.upperBound, trailings, &buffer)
                }
                for possible in possibles[range.lowerBound] {
                    self._variants(possibles, leadings + [ possible ], nextIndex ..< range.upperBound, trailings, &buffer)
                }
                currIndex = nextIndex
            }
        } else if leadings.count + trailings.count == possibles.count {
            buffer.append(leadings + trailings)
        }
    }
    
    func _build(
        by entity: Entity,
        in context: some MacroExpansionContext,
        variants: [Variant]
    ) -> InitializerDeclSyntax {
        let signature = FunctionSignatureSyntax(parameterClause: .init(parametersBuilder: {
            for variant in variants {
                if case .origin(let paramenter, _) = variant {
                    FunctionParameterSyntax(
                        firstName: .identifier(paramenter.label),
                        secondName: paramenter.name.flatMap({ .identifier($0) }),
                        type: IdentifierTypeSyntax(name: .identifier(paramenter.type))
                    )
                } else if case .builder(let paramenter, _, let type) = variant {
                    FunctionParameterSyntax(
                        attributes: [
                            .init(AttributeSyntax(
                                attributeName: IdentifierTypeSyntax(name: .identifier(type))
                            ))
                        ],
                        firstName: .identifier(paramenter.label),
                        secondName: paramenter.name.flatMap({ .identifier($0) }),
                        type: FunctionTypeSyntax(
                            parameters: [],
                            returnClause: .init(
                                type: IdentifierTypeSyntax(name: .identifier(paramenter.type))
                            )
                        )
                    )
                }
            }
        }))
        let genericWhereClause = GenericWhereClauseSyntax(requirementsBuilder: {
            for variant in variants {
                if case .default(let paramenter, _, let type) = variant {
                    let sameTypeRequirement = SameTypeRequirementSyntax(
                        leftType: IdentifierTypeSyntax(name: .identifier(paramenter.type)),
                        equal: .binaryOperator("=="),
                        rightType: IdentifierTypeSyntax(name: .identifier(type))
                    )
                    GenericRequirementSyntax(
                        requirement: .init(sameTypeRequirement)
                    )
                }
            }
        })
        return InitializerDeclSyntax(
            attributes: .init(itemsBuilder: {
                AttributeSyntax("@inlinable")
            }),
            modifiers: .init(itemsBuilder: {
                if let modifier = entity.modifier ?? self.modifier {
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
                if entity.target == .class || entity.target == .protocol {
                    .init(name: .keyword(.convenience))
                }
            }),
            optionalMark: self.isOptional == true ? .identifier("?") : nil,
            signature: signature,
            genericWhereClause: genericWhereClause.requirements.isEmpty == false ? genericWhereClause : nil,
            bodyBuilder: {
                FunctionCallExprSyntax(
                    callee: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                        name: .identifier("init")
                    ),
                    argumentList: {
                        for variant in variants {
                            switch variant {
                            case .origin(let parameter, _):
                                let expr = DeclReferenceExprSyntax(
                                    baseName: .identifier(parameter.name ?? parameter.label)
                                )
                                if parameter.name == nil {
                                    LabeledExprSyntax(
                                        label: parameter.label,
                                        expression: expr
                                    )
                                } else {
                                    LabeledExprSyntax(
                                        expression: expr
                                    )
                                }
                            case .builder(let parameter, _, _):
                                let expr = FunctionCallExprSyntax(
                                    callee: DeclReferenceExprSyntax(
                                        baseName: .identifier(parameter.name ?? parameter.label)
                                    )
                                )
                                if parameter.name == nil {
                                    LabeledExprSyntax(
                                        label: parameter.label,
                                        expression: expr
                                    )
                                } else {
                                    LabeledExprSyntax(
                                        expression: expr
                                    )
                                }
                            case .default(let parameter, _, let type):
                                let expr = FunctionCallExprSyntax(
                                    callee: DeclReferenceExprSyntax(
                                        baseName: .identifier(type)
                                    )
                                )
                                if parameter.name == nil {
                                    LabeledExprSyntax(
                                        label: parameter.label,
                                        expression: expr
                                    )
                                } else {
                                    LabeledExprSyntax(
                                        expression: expr
                                    )
                                }
                            }
                        }
                    }
                )
            }
        )
    }
    
}
