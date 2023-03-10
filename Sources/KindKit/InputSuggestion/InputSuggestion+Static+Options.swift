//
//  KindKit
//

import Foundation

public extension InputSuggestion.Static {
    
    struct Options : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension InputSuggestion.Static.Options {
    
    static let allowEmpty = Self(rawValue: 1 << 0)
    static let caseSensitive = Self(rawValue: 1 << 1)

}

extension InputSuggestion.Static.Options {
    
    var makeItem: (String) -> InputSuggestion.Static.Item {
        if self.contains(.caseSensitive) == true {
            return { string in
                return InputSuggestion.Static.Item(
                    origin: string,
                    search: string
                )
            }
        }
        return { string in
            return InputSuggestion.Static.Item(
                origin: string,
                search: string.lowercased()
            )
        }
    }
    
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
