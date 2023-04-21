//
//  KindKit
//

import Foundation

public extension UI.Markdown.Text {
    
    struct Options : OptionSet, Hashable {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.Markdown.Text.Options {
    
    static let italic = Self(rawValue: 1 << 0)
    static let bold = Self(rawValue: 1 << 1)
    static let underline = Self(rawValue: 1 << 2)
    static let strikethrough = Self(rawValue: 1 << 3)

}
