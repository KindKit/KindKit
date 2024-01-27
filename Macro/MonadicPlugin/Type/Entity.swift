//
//  KindKit
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

final class Entity {
    
    let target: Target
    let modifiers: DeclModifierListSyntax
    let name: String
    var genericTypes: [String] = []
    var constructors: [Constructor] = []
    var variables: [Variable] = []
    var fields: [Field] = []
    var fieldAliases: [FieldAlias] = []
    var signals: [Signal] = []
    
    fileprivate init(
        target: Target,
        name: String,
        syntax: DeclGroupSyntax
    ) {
        self.target = target
        self.modifiers = syntax.modifiers
        self.name = name
        
        Self.collect(
            syntax: syntax.memberBlock.members,
            constructors: &self.constructors,
            variables: &self.variables,
            fields: &self.fields,
            fieldAliases: &self.fieldAliases,
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
    
    func variable(name: String) -> Variable? {
        return self.variables.first(where: { $0.name == name })
    }
    
    func field(name: String) -> Field? {
        return self.fields.first(where: { $0.variable.name == name })
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
            for fieldAlias in self.fieldAliases {
                if let syntax = fieldAlias.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for field in self.fields {
                if let syntax = field.build(by: self, in: context) {
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
            for fieldAlias in self.fieldAliases {
                if let syntax = fieldAlias.build(by: self, in: context) {
                    result.append(contentsOf: syntax.map(\.decl))
                }
            }
            for field in self.fields {
                if let syntax = field.build(by: self, in: context) {
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
    ) -> [ExtensionDeclSyntax]? {
        switch self.target {
        case .struct, .class:
            return nil
        case .protocol:
            let monadicExtension = ExtensionDeclSyntax(
                modifiers: self.modifiers,
                extendedType: IdentifierTypeSyntax(name: .identifier(self.name)),
                memberBlockBuilder: {
                    for fieldAlias in self.fieldAliases {
                        if let syntax = fieldAlias.build(by: self, in: context) {
                            syntax
                        }
                    }
                    for field in self.fields {
                        if let syntax = field.build(by: self, in: context) {
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
            return [ monadicExtension ]
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
        fields: inout [Field],
        fieldAliases: inout [FieldAlias],
        signals: inout [Signal]
    ) {
        for member in syntax {
            if let syntax = member.decl.as(VariableDeclSyntax.self) {
                Self.collect(
                    syntax: syntax,
                    compileTime: compileTime,
                    variables: &variables,
                    fields: &fields,
                    fieldAliases: &fieldAliases,
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
                        fields: &fields,
                        fieldAliases: &fieldAliases,
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
        fields: inout [Field],
        fieldAliases: inout [FieldAlias],
        signals: inout [Signal]
    ) {
        let attributes = syntax.attributes.compactMap(Attribute.init)
        for bindingSyntax in syntax.bindings {
            guard let variable = Variable(compileTime: compileTime, variableSyntax: syntax, bindingSyntax: bindingSyntax) else {
                continue
            }
            variables.append(variable)
            
            if attributes.isEmpty == false {
                var tempFields: [Field] = []
                var tempFieldAliases: [FieldAlias] = []
                var tempSignals: [Signal] = []
                for attribute in attributes {
                    switch attribute {
                    case .field:
                        if let field = tempFields.first(where: { $0.variable === variable }) {
                            field.setters = true
                        } else {
                            tempFields.append(Field(
                                variable: variable,
                                setters: true
                            ))
                        }
                    case .fieldAlias(let alias):
                        tempFieldAliases.append(FieldAlias(
                            alias: alias,
                            variable: variable
                        ))
                    case .fieldBuilder(let type):
                        if let field = tempFields.first(where: { $0.variable === variable }) {
                            field.builder = type
                        } else {
                            tempFields.append(Field(
                                variable: variable,
                                builder: type
                            ))
                        }
                    case .fieldDefault(let type):
                        if let field = tempFields.first(where: { $0.variable === variable }) {
                            field.default = type
                        } else {
                            tempFields.append(Field(
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
                fields.append(contentsOf: tempFields)
                fieldAliases.append(contentsOf: tempFieldAliases)
                signals.append(contentsOf: tempSignals)
                for alias in tempFieldAliases {
                    for origin in tempFields {
                        fields.append(origin.copy(
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
