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
        
        let variablesSyntax = syntax.memberBlock.members.compactMap({ $0.decl.as(VariableDeclSyntax.self) })
        for variableSyntax in variablesSyntax {
            let attributes = variableSyntax.attributes.compactMap(Attribute.init)
            for bindingSyntax in variableSyntax.bindings {
                guard let variable = Variable(variableSyntax: variableSyntax, bindingSyntax: bindingSyntax) else {
                    continue
                }
                self.variables.append(variable)
                
                if attributes.isEmpty == false {
                    var aliases: [Alias] = []
                    var properties: [Property] = []
                    var signals: [Signal] = []
                    for attribute in attributes {
                        switch attribute {
                        case .alias(let alias): aliases.append(Alias(alias: alias, variable: variable))
                        case .property: properties.append(Property(variable: variable))
                        case .signal: signals.append(Signal(variable: variable))
                        }
                    }
                    self.aliases.append(contentsOf: aliases)
                    self.properties.append(contentsOf: properties)
                    self.signals.append(contentsOf: signals)
                    for alias in aliases {
                        for origin in properties {
                            self.properties.append(origin.copy(name: alias.alias))
                        }
                        for origin in signals {
                            self.signals.append(origin.copy(name: alias.alias))
                        }
                    }
                }
            }
        }
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
