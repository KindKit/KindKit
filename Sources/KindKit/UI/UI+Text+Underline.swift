//
//  KindKit
//

import Foundation

public extension UI.Text {

    struct Underline : OptionSet {
        
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.Text.Underline {
    
    static var single = UI.Text.Underline(rawValue: 1 << 0)
    static var thick = UI.Text.Underline(rawValue: 1 << 1)
    static var double = UI.Text.Underline(rawValue: 1 << 2)
    static var patternDot = UI.Text.Underline(rawValue: 1 << 3)
    static var patternDash = UI.Text.Underline(rawValue: 1 << 4)
    static var patternDashDot = UI.Text.Underline(rawValue: 1 << 5)
    static var patternDashDotDot = UI.Text.Underline(rawValue: 1 << 6)
    static var byWord = UI.Text.Underline(rawValue: 1 << 7)

}
