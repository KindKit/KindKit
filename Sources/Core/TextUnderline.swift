//
//  KindKit
//

import Foundation

public struct TextUnderline : OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}

public extension TextUnderline {
    
    static var single = TextUnderline(rawValue: 1 << 0)
    static var thick = TextUnderline(rawValue: 1 << 1)
    static var double = TextUnderline(rawValue: 1 << 2)
    static var patternDot = TextUnderline(rawValue: 1 << 3)
    static var patternDash = TextUnderline(rawValue: 1 << 4)
    static var patternDashDot = TextUnderline(rawValue: 1 << 5)
    static var patternDashDotDot = TextUnderline(rawValue: 1 << 6)
    static var byWord = TextUnderline(rawValue: 1 << 7)

}
