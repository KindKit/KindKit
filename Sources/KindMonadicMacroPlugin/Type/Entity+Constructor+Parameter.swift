//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Entity.Constructor {
    
    final class Parameter {
        
        let label: String
        let name: String?
        let type: String
        
        init(
            syntax: FunctionParameterSyntax
        ) {
            self.label = syntax.firstName.trimmedDescription
            self.name = syntax.secondName?.trimmedDescription
            self.type = syntax.type.trimmedDescription
        }
        
    }
    
}
