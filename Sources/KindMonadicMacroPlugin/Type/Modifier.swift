//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum Modifier {
    
    case none
    case `internal`
    case `fileprivate`
    case `private`
    case `public`
    
    init(_ syntax: ProtocolDeclSyntax) {
        self.init(syntax.modifiers)
    }
    
    init(_ syntax: VariableDeclSyntax) {
        self.init(syntax.modifiers)
    }
    
    init(_ syntax: DeclModifierListSyntax) {
        guard let first = syntax.first else {
            self = .none
            return
        }
        self.init(first)
    }
    
    init(_ syntax: DeclModifierSyntax) {
        switch syntax.trimmed.description {
        case "internal": self = .internal
        case "fileprivate": self = .fileprivate
        case "private": self = .private
        case "public": self = .public
        default: self = .none
        }
    }
    
    func build() -> DeclModifierListSyntax {
        switch self {
        case .none: return []
        case .internal: return .init(itemsBuilder: { .init(name: .keyword(.internal)) })
        case .fileprivate: return .init(itemsBuilder: { .init(name: .keyword(.fileprivate)) })
        case .private: return .init(itemsBuilder: { .init(name: .keyword(.private)) })
        case .public: return .init(itemsBuilder: { .init(name: .keyword(.public)) })
        }
    }
    
}
