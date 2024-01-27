//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum Modifier {
    
    case `internal`
    case `fileprivate`
    case `private`
    case `public`
    
    init?(_ syntax: ProtocolDeclSyntax) {
        self.init(syntax.modifiers)
    }
    
    init?(_ syntax: VariableDeclSyntax) {
        self.init(syntax.modifiers)
    }
    
    init?(_ syntax: DeclModifierListSyntax) {
        let list = syntax.compactMap({ Modifier($0) })
        if let first = list.first {
            self = first
        } else {
            return nil
        }
    }
    
    init?(_ syntax: DeclModifierSyntax) {
        switch syntax.name.tokenKind {
        case .keyword(.internal): self = .internal
        case .keyword(.fileprivate): self = .fileprivate
        case .keyword(.private): self = .private
        case .keyword(.public): self = .public
        default: return nil
        }
    }
    
}
