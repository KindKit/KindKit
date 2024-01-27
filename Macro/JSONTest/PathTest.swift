//
//  TestMacro
//

#if os(macOS)

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import KindJSONMacro
@testable import KindJSONMacroPlugin

final class PathTest : XCTestCase {
    
    func test() {
        assertMacroExpansion(
            #"""
            let path = #Path("root")
            """#,
            expandedSource: #"""
            let path = KindJSONPath.Path(["root"])
            """#,
            macros: [
                "Path": PathMacro.self
            ]
        )
        assertMacroExpansion(
            #"""
            let path = #Path("root", 0)
            """#,
            expandedSource: #"""
            let path = KindJSONPath.Path(["root", 0])
            """#,
            macros: [
                "Path": PathMacro.self
            ]
        )
    }
     
}

#endif
