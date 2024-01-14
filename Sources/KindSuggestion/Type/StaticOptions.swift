//
//  KindKit
//

public struct StaticOptions : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension StaticOptions {
    
    static let allowEmpty = Self(rawValue: 1 << 0)
    static let caseSensitive = Self(rawValue: 1 << 1)

}

extension StaticOptions {
    
    var search: (String) -> String {
        if self.contains(.caseSensitive) == true {
            return { string in
                return string
            }
        }
        return { string in
            return string.lowercased()
        }
    }
    
}
