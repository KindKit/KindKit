//
//  KindMacro
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

extension Variable.Accessors.Item {
    
    struct Flags : OptionSet {
        
        var rawValue: UInt
        
        init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        init(_ syntax: AccessorDeclSyntax) {
            if syntax.body != nil {
                self = [ .computed ]
            } else {
                self = []
            }
        }
        
        static let computed = Self.init(rawValue: 1 << 0)
        
    }
    
}
