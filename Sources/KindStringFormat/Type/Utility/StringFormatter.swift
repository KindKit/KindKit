//
//  KindKit
//

import KindString

public struct StringFormatter : IFormatter {
    
    public init() {
    }

    public func argument(_ argument: IArgument, specifier: Specifier) -> String {
        return argument.string(specifier)
    }
    
    public func placeholder(_ placeholder: String) -> String {
        return placeholder
    }
    
    public func undefined() -> String {
        return ""
    }
    
}
