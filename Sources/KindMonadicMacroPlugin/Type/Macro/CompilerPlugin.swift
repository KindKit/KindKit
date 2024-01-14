//
//  KindMacro
//

import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct CompilerPlugin : SwiftCompilerPlugin.CompilerPlugin {
    
    let providingMacros: [Macro.Type] = [
        ExpansionMacro.self,
        DummyMacro.self
    ]
    
}
