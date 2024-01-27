//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

final class Entity {
    
    let target: Target
    let modifier: Modifier
    let name: String
    var variables: [Variable] = []
    var aliases: [Alias] = []
    var properties: [Property] = []
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
            variables: &self.variables,
            aliases: &self.aliases,
            properties: &self.properties,
            signals: &self.signals
        )
    }
    
    convenience init(_ syntax: StructDeclSyntax) {
        self.init(
            target: .struct,
            name: syntax.name.trimmed.text,
            syntax: syntax
        )
    }
    
    convenience init(_ syntax: ClassDeclSyntax) {
        self.init(
            target: .class,
            name: syntax.name.trimmed.text,
            syntax: syntax
        )
    }
    
    convenience init(_ syntax: ProtocolDeclSyntax) {
        self.init(
            target: .protocol,
            name: syntax.name.trimmed.text,
            syntax: syntax
        )
    }
    
    func build(
        in context: some MacroExpansionContext
    ) -> [DeclSyntax]? {
        switch self.target {
        case .struct:
            var result: [DeclSyntax] = []
            for alias in self.aliases {
                if let syntax = alias.build(by: self, in: context) {
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
            for alias in self.aliases {
                if let syntax = alias.build(by: self, in: context) {
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
                modifiers: self.modifier.build(),
                extendedType: IdentifierTypeSyntax(name: .identifier(self.name)),
                memberBlockBuilder: {
                    for alias in self.aliases {
                        if let syntax = alias.build(by: self, in: context) {
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
        syntax: MemberBlockItemListSyntax,
        compileTime: CompileTimeCondition? = nil,
        variables: inout [Variable],
        aliases: inout [Alias],
        properties: inout [Property],
        signals: inout [Signal]
    ) {
        for member in syntax {
            if let syntax = member.decl.as(VariableDeclSyntax.self) {
                Self.collect(
                    syntax: syntax,
                    compileTime: compileTime,
                    variables: &variables,
                    aliases: &aliases,
                    properties: &properties,
                    signals: &signals
                )
            } else if let syntax = member.decl.as(IfConfigDeclSyntax.self) {
                for clause in syntax.clauses {
                    guard let members = clause.elements?.as(MemberBlockItemListSyntax.self) else { continue }
                    guard let compileTime = CompileTimeCondition(clause) else { continue }
                    Self.collect(
                        syntax: members,
                        compileTime: compileTime,
                        variables: &variables,
                        aliases: &aliases,
                        properties: &properties,
                        signals: &signals
                    )
                }
            }
        }
    }
    
    static func collect(
        syntax: VariableDeclSyntax,
        compileTime: CompileTimeCondition? = nil,
        variables: inout [Variable],
        aliases: inout [Alias],
        properties: inout [Property],
        signals: inout [Signal]
    ) {
        let attributes = syntax.attributes.compactMap(Attribute.init)
        for bindingSyntax in syntax.bindings {
            guard let variable = Variable(compileTime: compileTime, variableSyntax: syntax, bindingSyntax: bindingSyntax) else {
                continue
            }
            variables.append(variable)
            
            if attributes.isEmpty == false {
                var tempAliases: [Alias] = []
                var tempProperties: [Property] = []
                var tempSignals: [Signal] = []
                for attribute in attributes {
                    switch attribute {
                    case .alias(let alias): tempAliases.append(Alias(alias: alias, variable: variable))
                    case .property: tempProperties.append(Property(variable: variable))
                    case .signal: tempSignals.append(Signal(variable: variable))
                    }
                }
                aliases.append(contentsOf: tempAliases)
                properties.append(contentsOf: tempProperties)
                signals.append(contentsOf: tempSignals)
                for alias in tempAliases {
                    for origin in tempProperties {
                        properties.append(origin.copy(name: alias.alias))
                    }
                    for origin in signals {
                        signals.append(origin.copy(name: alias.alias))
                    }
                }
            }
        }
    }
    
}
