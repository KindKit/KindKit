//
//  KindKit
//

public struct OverrideFinder : Finder {
    
    public var override: (any Finder)?
    
    public var `default`: any Finder
    
    public init(
        override: (any Finder)? = nil,
        `default`: any Finder
    ) {
        self.override = override
        self.default = `default`
    }
    
    public func callAsFunction(key: String) -> String? {
        if let string = self.override?(key: key) {
            return string
        }
        return self.default(key: key)
    }
    
}
