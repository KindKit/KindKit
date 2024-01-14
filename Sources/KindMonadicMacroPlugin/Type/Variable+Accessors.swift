//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Variable {
    
    struct Accessors {
        
        let items: [Item]
        
        init() {
            self.items = []
        }
        
        init(_ syntax: AccessorBlockSyntax) {
            if let accessors = syntax.accessors.as(AccessorDeclListSyntax.self) {
                self.items = accessors.compactMap(Item.init)
            } else if syntax.accessors.is(CodeBlockItemListSyntax.self) == true {
                self.items = [
                    .init(name: .get, flags: .computed)
                ]
            } else {
                self.items = []
            }
        }
        
        init(_ syntax: PatternBindingSyntax) {
            if let accessorBlock = syntax.accessorBlock {
                self.init(accessorBlock)
            } else {
                self.init()
            }
        }
        
    }
    
}
