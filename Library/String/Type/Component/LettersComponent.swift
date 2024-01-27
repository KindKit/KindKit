//
//  KindKit
//

import KindLocalize

public struct LettersComponent : Component {
    
    public let string: String
    
    public init(_ string: String) {
        self.string = string
    }
    
    public init(_ string: String, escape: EscapeMode) {
        self.string = escape.apply(string)
    }
    
    public init< Input : CustomStringConvertible >(_ input: Input) {
        self.string = input.description
    }
    
    public init< Input : CustomStringConvertible >(_ input: Input, escape: EscapeMode) {
        self.string = escape.apply(input.description)
    }
    
    public init(_ key: Key) {
        self.string = key.string
    }
    
}
