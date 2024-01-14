//
//  KindKit
//

import Foundation

public extension Text {

    struct Strikethrough : OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Text.Strikethrough {
    
    static var single = Text.Strikethrough(rawValue: 1 << 0)
    static var thick = Text.Strikethrough(rawValue: 1 << 1)
    static var double = Text.Strikethrough(rawValue: 1 << 2)
    static var patternDot = Text.Strikethrough(rawValue: 1 << 3)
    static var patternDash = Text.Strikethrough(rawValue: 1 << 4)
    static var patternDashDot = Text.Strikethrough(rawValue: 1 << 5)
    static var patternDashDotDot = Text.Strikethrough(rawValue: 1 << 6)
    static var byWord = Text.Strikethrough(rawValue: 1 << 7)

}
