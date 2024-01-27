//
//  KindKit
//

import SwiftSyntax

extension VariableDeclSyntax {
    
    var isVar: Bool {
        return self.bindingSpecifier.tokenKind == .keyword(.var)
    }
    
    var isLet: Bool {
        return self.bindingSpecifier.tokenKind == .keyword(.let)
    }
    
}
