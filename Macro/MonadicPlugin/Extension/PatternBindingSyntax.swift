//
//  KindKit
//

import SwiftSyntax

extension PatternBindingSyntax {
    
    var name: String? {
        if let syntax = self.pattern.as(IdentifierPatternSyntax.self) {
            return syntax.identifier.text
        }
        return nil
    }
    
    var type: String? {
        if let syntax = self.typeAnnotation {
            return syntax.type.trimmed.description
        } else if let syntax = self.initializer?.value.as(FunctionCallExprSyntax.self) {
            return syntax.trimmed.description
        }
        return nil
    }
    
}
