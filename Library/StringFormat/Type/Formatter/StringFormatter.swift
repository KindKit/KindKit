//
//  KindKit
//

import KindString

public struct StringFormatter : Formatter {
    
    public init() {
    }

    public func argument(_ argument: any Argument, specifier: Specifier) -> String {
        return argument.string(specifier)
    }
    
    public func placeholder(_ placeholder: String) -> String {
        return placeholder
    }
    
    public func undefined() -> String {
        return ""
    }
    
}
