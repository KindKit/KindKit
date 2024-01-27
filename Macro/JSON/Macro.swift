//
//  KindKit
//

import KindJSONPath

@freestanding(expression)
public macro Path(_ items: Any...) -> Path = #externalMacro(
    module: "KindJSONMacroPlugin",
    type: "PathMacro"
)
