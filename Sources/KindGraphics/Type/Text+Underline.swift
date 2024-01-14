//
//  KindKit
//

import Foundation

public extension Text {

    struct Underline : OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Text.Underline {
    
    static var single = Text.Underline(rawValue: 1 << 0)
    static var thick = Text.Underline(rawValue: 1 << 1)
    static var double = Text.Underline(rawValue: 1 << 2)
    static var patternDot = Text.Underline(rawValue: 1 << 3)
    static var patternDash = Text.Underline(rawValue: 1 << 4)
    static var patternDashDot = Text.Underline(rawValue: 1 << 5)
    static var patternDashDotDot = Text.Underline(rawValue: 1 << 6)
    static var byWord = Text.Underline(rawValue: 1 << 7)

}
