//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

final class CompileTimeCondition {
    
    let keyword: Keyword
    let condition: ExprSyntax?
    
    init?(_ syntax: IfConfigClauseSyntax) {
        switch syntax.poundKeyword.tokenKind {
        case .poundIf:
            self.keyword = .if
            self.condition = syntax.condition
        case .poundElseif:
            self.keyword = .elseif
            self.condition = syntax.condition
        case .poundElse:
            self.keyword = .elseif
            self.condition = nil
        default:
            return nil
        }
    }
    
}
