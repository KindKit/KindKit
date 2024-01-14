//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct ExpansionMacro : MemberMacro, ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        var expansion: [DeclSyntax] = []
        if let declaration = declaration.as(StructDeclSyntax.self) {
            let entity = Entity(declaration)
            if let build: [DeclSyntax] = entity.build(in: context) {
                expansion.append(contentsOf: build)
            }
        } else if let declaration = declaration.as(ClassDeclSyntax.self) {
            let entity = Entity(declaration)
            if let build: [DeclSyntax] = entity.build(in: context) {
                expansion.append(contentsOf: build)
            }
        }
        return expansion
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        var expansion: [ExtensionDeclSyntax] = []
        if let declaration = declaration.as(ProtocolDeclSyntax.self) {
            let entity = Entity(declaration)
            if let build: ExtensionDeclSyntax = entity.build(in: context) {
                expansion.append(build)
            }
        }
        return expansion
    }
    
}
