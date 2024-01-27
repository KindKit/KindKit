//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension CompileTimeCondition {
    
    enum Keyword {
        
        case `if`
        case `elseif`
        case `else`
        
    }
    
}
