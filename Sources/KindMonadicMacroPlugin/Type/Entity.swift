//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

final class Entity {
    
    let target: Target
    let modifier: Modifier?
    let name: String
    var genericTypes: [String] = []
    var constructors: [Constructor] = []
    var variables: [Variable] = []
    var properties: [Property] = []
    var propertyAliases: [PropertyAlias] = []
    var signals: [Signal] = []
    
    fileprivate init(
        target: Target,
        name: String,
        syntax: DeclGroupSyntax
    ) {
        self.target = target
        self.modifier = .init(syntax.modifiers)
        self.name = name
        
        Self.collect(
            syntax: syntax.memberBlock.members,
            constructors: &self.constructors,
            variables: &self.variables,
            properties: &self.properties,
            propertyAliases: &self.propertyAliases,
            signals: &self.signals
        )
    }
    
    convenience init(_ syntax: StructDeclSyntax) {
        self.init(
            target: .struct,
            name: syntax.name.trimmed.text,
            syntax: syntax
        )
        Self.collect(
            syntax: syntax,
            genericTypes: &self.genericTypes
        )
    }
    
    convenience init(_ syntax: ClassDeclSyntax) {
        self.init(
            target: .class,
            name: syntax.name.trimmed.text,
            syntax: syntax
        )
        Self.collect(
            syntax: syntax,
            genericTypes: &self.genericTypes
        )
    }
    
    convenience init(_ syntax: ProtocolDeclSyntax) {
        self.init(
            target: .protocol,
            name: syntax.name.trimmed.text,
            syntax: syntax
        )
    }
    
    func property(name: String) -> Property? {
        return self.properties.first(where: { $0.variable.name == name })
    }
    
    func build(
        in context: some MacroExpansionContext
    ) -> [DeclSyntax]? {
        switch self.target {
        case .struct:
            var result: [DeclSyntax] = []
            for constructor in self.constructors {
                if let syntax = constructor.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for propertyAlias in self.propertyAliases {
                if let syntax = propertyAlias.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for property in self.properties {
                if let syntax = property.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            return result
        case .class:
            var result: [DeclSyntax] = []
            for constructor in self.constructors {
                if let syntax = constructor.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for propertyAlias in self.propertyAliases {
                if let syntax = propertyAlias.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for property in self.properties {
                if let syntax = property.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for signal in self.signals {
                if let syntax = signal.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            return result
        case .protocol:
            return nil
        }
    }
    
    func build(
        in context: some MacroExpansionContext
    ) -> ExtensionDeclSyntax? {
        switch self.target {
        case .struct, .class:
            return nil
        case .protocol:
            return ExtensionDeclSyntax(
                modifiers: .init(itemsBuilder: {
                    if let modifier = self.modifier {
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
                extendedType: IdentifierTypeSyntax(name: .identifier(self.name)),
                memberBlockBuilder: {
                    for propertyAlias in self.propertyAliases {
                        if let syntax = propertyAlias.build(by: self, in: context) {
                            syntax
                        }
                    }
                    for property in self.properties {
                        if let syntax = property.build(by: self, in: context) {
                            syntax
                        }
                    }
                    for signal in self.signals {
                        if let syntax = signal.build(by: self, in: context) {
                            syntax
                        }
                    }
                }
            )
        }
    }
    
}

fileprivate extension Entity {
    
    static func collect(
        syntax: StructDeclSyntax,
        genericTypes: inout [String]
    ) {
        guard let genericParameterClause = syntax.genericParameterClause else {
            return
        }
        for genericParameter in genericParameterClause.parameters {
            genericTypes.append(genericParameter.name.trimmedDescription)
        }
    }
    
    static func collect(
        syntax: ClassDeclSyntax,
        genericTypes: inout [String]
    ) {
        guard let genericParameterClause = syntax.genericParameterClause else {
            return
        }
        for genericParameter in genericParameterClause.parameters {
            genericTypes.append(genericParameter.name.trimmedDescription)
        }
    }
    
    static func collect(
        syntax: MemberBlockItemListSyntax,
        compileTime: CompileTimeCondition? = nil,
        constructors: inout [Constructor],
        variables: inout [Variable],
        properties: inout [Property],
        propertyAliases: inout [PropertyAlias],
        signals: inout [Signal]
    ) {
        for member in syntax {
            if let syntax = member.decl.as(VariableDeclSyntax.self) {
                Self.collect(
                    syntax: syntax,
                    compileTime: compileTime,
                    variables: &variables,
                    properties: &properties,
                    propertyAliases: &propertyAliases,
                    signals: &signals
                )
            } else if let syntax = member.decl.as(InitializerDeclSyntax.self) {
                Self.collect(
                    syntax: syntax,
                    compileTime: compileTime,
                    constructors: &constructors
                )
            } else if let syntax = member.decl.as(IfConfigDeclSyntax.self) {
                for clause in syntax.clauses {
                    guard let members = clause.elements?.as(MemberBlockItemListSyntax.self) else { continue }
                    guard let compileTime = CompileTimeCondition(clause) else { continue }
                    Self.collect(
                        syntax: members,
                        compileTime: compileTime,
                        constructors: &constructors,
                        variables: &variables,
                        properties: &properties,
                        propertyAliases: &propertyAliases,
                        signals: &signals
                    )
                }
            }
        }
    }
    
    static func collect(
        syntax: InitializerDeclSyntax,
        compileTime: CompileTimeCondition?,
        constructors: inout [Constructor]
    ) {
        guard let constructor = Constructor(compileTime: compileTime, syntax: syntax) else {
            return
        }
        constructors.append(constructor)
    }
    
    static func collect(
        syntax: VariableDeclSyntax,
        compileTime: CompileTimeCondition?,
        variables: inout [Variable],
        properties: inout [Property],
        propertyAliases: inout [PropertyAlias],
        signals: inout [Signal]
    ) {
        let attributes = syntax.attributes.compactMap(Attribute.init)
        for bindingSyntax in syntax.bindings {
            guard let variable = Variable(compileTime: compileTime, variableSyntax: syntax, bindingSyntax: bindingSyntax) else {
                continue
            }
            variables.append(variable)
            
            if attributes.isEmpty == false {
                var tempProperties: [Property] = []
                var tempPropertyAliases: [PropertyAlias] = []
                var tempSignals: [Signal] = []
                for attribute in attributes {
                    switch attribute {
                    case .property:
                        if let property = tempProperties.first(where: { $0.variable === variable }) {
                            property.setters = true
                        } else {
                            tempProperties.append(Property(
                                variable: variable,
                                setters: true
                            ))
                        }
                    case .propertyAlias(let alias):
                        tempPropertyAliases.append(PropertyAlias(
                            alias: alias,
                            variable: variable
                        ))
                    case .propertyBuilder(let type):
                        if let property = tempProperties.first(where: { $0.variable === variable }) {
                            property.builder = type
                        } else {
                            tempProperties.append(Property(
                                variable: variable,
                                builder: type
                            ))
                        }
                    case .propertyDefault(let type):
                        if let property = tempProperties.first(where: { $0.variable === variable }) {
                            property.default = type
                        } else {
                            tempProperties.append(Property(
                                variable: variable,
                                default: type
                            ))
                        }
                    case .signal:
                        tempSignals.append(Signal(
                            variable: variable
                        ))
                    }
                }
                properties.append(contentsOf: tempProperties)
                propertyAliases.append(contentsOf: tempPropertyAliases)
                signals.append(contentsOf: tempSignals)
                for alias in tempPropertyAliases {
                    for origin in tempProperties {
                        properties.append(origin.copy(
                            name: alias.alias
                        ))
                    }
                    for origin in signals {
                        signals.append(origin.copy(
                            name: alias.alias
                        ))
                    }
                }
            }
        }
    }
    
}
