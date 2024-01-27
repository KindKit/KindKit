//
//  KindKit
//

import KindString

public struct StringArgument : IArgument {
    
    let value: String
    let fallback: String
    
    public init(_ value: String, fallback: String = "") {
        self.value = value
        self.fallback = fallback
    }
    
    public init(@Builder _ builder: () -> String, fallback: String = "") {
        self.value = builder()
        self.fallback = fallback
    }
    
    public func string(_ specifier: Specifier) -> String {
        guard let value = specifier.format(self.value) else {
            return self.fallback
        }
        return value
    }
    
}
