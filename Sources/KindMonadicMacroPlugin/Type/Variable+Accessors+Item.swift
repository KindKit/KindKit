//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Variable.Accessors {
    
    struct Item {
        
        let name: Name
        let flags: Flags
        
        init(
            name: Name,
            flags: Flags
        ) {
            self.name = name
            self.flags = flags
        }
        
        init?(_ syntax: AccessorDeclSyntax) {
            guard let name = Name(syntax.accessorSpecifier) else { return nil }
            self.name = name
            self.flags = .init(syntax)
        }
        
    }
    
}
