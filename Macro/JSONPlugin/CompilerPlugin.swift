//
//  KindMacro
//

import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct CompilerPlugin : SwiftCompilerPlugin.CompilerPlugin {
    
    let providingMacros: [Macro.Type] = [
        PathMacro.self
    ]
    
}
