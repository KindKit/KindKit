//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    struct StaticOptions : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension InputSuggestion.StaticOptions {
    
    static let allowEmpty = Self(rawValue: 1 << 0)
    static let caseSensitive = Self(rawValue: 1 << 1)

}

extension InputSuggestion.StaticOptions {
    
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
