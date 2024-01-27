//
//  KindKit
//

import SwiftSyntax

extension DeclModifierSyntax {
    
    static var `internal`: DeclModifierSyntax {
        return .init(name: .keyword(.internal))
    }
    
    var isInternal: Bool {
        return self.has(keyword: .internal)
    }
    
    static var internalSet: DeclModifierSyntax {
        return .init(name: .keyword(.internal), detail: .init(detail: .keyword(.set)))
    }
    
    var isInternalSet: Bool {
        return self.has(keyword: .internal, detail: .set)
    }
    
    static var internalGet: DeclModifierSyntax {
        return .init(name: .keyword(.internal), detail: .init(detail: .keyword(.get)))
    }
    
    var isInternalGet: Bool {
        return self.has(keyword: .internal, detail: .get)
    }
    
}

extension DeclModifierSyntax {
    
    static var `fileprivate`: DeclModifierSyntax {
        return .init(name: .keyword(.fileprivate))
    }
    
    var isFileprivate: Bool {
        return self.has(keyword: .fileprivate)
    }
    
    static var fileprivateSet: DeclModifierSyntax {
        return .init(name: .keyword(.fileprivate), detail: .init(detail: .keyword(.set)))
    }
    
    var isFileprivateSet: Bool {
        return self.has(keyword: .fileprivate, detail: .set)
    }
    
    static var fileprivateGet: DeclModifierSyntax {
        return .init(name: .keyword(.fileprivate), detail: .init(detail: .keyword(.get)))
    }
    
    var isFileprivateGet: Bool {
        return self.has(keyword: .fileprivate, detail: .get)
    }
    
}

extension DeclModifierSyntax {
    
    static var `private`: DeclModifierSyntax {
        return .init(name: .keyword(.private))
    }
    
    var isPrivate: Bool {
        return self.has(keyword: .private)
    }
    
    static var privateSet: DeclModifierSyntax {
        return .init(name: .keyword(.private), detail: .init(detail: .keyword(.set)))
    }
    
    var isPrivateSet: Bool {
        return self.has(keyword: .private, detail: .set)
    }
    
    static var privateGet: DeclModifierSyntax {
        return .init(name: .keyword(.private), detail: .init(detail: .keyword(.get)))
    }
    
    var isPrivateGet: Bool {
        return self.has(keyword: .private, detail: .get)
    }
    
}

extension DeclModifierSyntax {
    
    static var `public`: DeclModifierSyntax {
        return .init(name: .keyword(.public))
    }
    
    var isPublic: Bool {
        return self.has(keyword: .public)
    }
    
    static var publicSet: DeclModifierSyntax {
        return .init(name: .keyword(.public), detail: .init(detail: .keyword(.set)))
    }
    
    var isPublicSet: Bool {
        return self.has(keyword: .public, detail: .set)
    }
    
    static var publicGet: DeclModifierSyntax {
        return .init(name: .keyword(.public), detail: .init(detail: .keyword(.get)))
    }
    
    var isPublicGet: Bool {
        return self.has(keyword: .public, detail: .get)
    }
    
}

extension DeclModifierSyntax {
    
    var contains: DeclModifierListSyntax.Contains {
        guard case .keyword(let keywordToken) = self.name.tokenKind else { return [] }
        if case .keyword(let detailToken) = self.detail?.detail.tokenKind {
            switch (keywordToken, detailToken) {
            case (.internal, .set): return .internalSet
            case (.internal, .get): return .internalGet
            case (.fileprivate, .set): return .fileprivateSet
            case (.fileprivate, .get): return .fileprivateGet
            case (.private, .set): return .privateGet
            case (.private, .get): return .privateGet
            case (.public, .set): return .publicGet
            case (.public, .get): return .publicGet
            default: return []
            }
        } else {
            switch keywordToken {
            case .internal: return .internal
            case .fileprivate: return .fileprivate
            case .private: return .private
            case .public: return .public
            default: return []
            }
        }
    }
    
}

fileprivate extension DeclModifierSyntax {
    
    func has(keyword: Keyword) -> Bool {
        guard case .keyword(let keywordToken) = self.name.tokenKind else { return false }
        return keywordToken == keyword && self.detail == nil
    }
    
    func has(keyword: Keyword, detail: Keyword) -> Bool {
        guard case .keyword(let keywordToken) = self.name.tokenKind else {
            return false
        }
        guard keywordToken == keyword else {
            return false
        }
        if let detailToken = self.detail?.detail {
            return detailToken == .keyword(detail)
        }
        return true
    }
    
}

extension DeclModifierSyntax {
    
    static func constructor(entity: DeclModifierListSyntax, base: DeclModifierListSyntax) -> DeclModifierSyntax? {
        if let modifier = entity.first {
            if case .keyword(let keyword) = modifier.name.tokenKind {
                switch keyword {
                case .internal: return .internal
                case .fileprivate: return .fileprivate
                case .private: return .private
                case .public: return .public
                default: break
                }
            }
        } else if let modifier = base.first {
            if case .keyword(let keyword) = modifier.name.tokenKind {
                switch keyword {
                case .internal: return .internal
                case .fileprivate: return .fileprivate
                case .private: return .private
                case .public: return .public
                default: break
                }
            }
        }
        return nil
    }
    
}
