//
//  KindKitView
//

import Foundation

public struct TextUnderline : OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var single: TextUnderline = TextUnderline(rawValue: 1 << 0)
    public static var thick: TextUnderline = TextUnderline(rawValue: 1 << 1)
    public static var double: TextUnderline = TextUnderline(rawValue: 1 << 2)
    public static var patternDot: TextUnderline = TextUnderline(rawValue: 1 << 3)
    public static var patternDash: TextUnderline = TextUnderline(rawValue: 1 << 4)
    public static var patternDashDot: TextUnderline = TextUnderline(rawValue: 1 << 5)
    public static var patternDashDotDot: TextUnderline = TextUnderline(rawValue: 1 << 6)
    public static var byWord: TextUnderline = TextUnderline(rawValue: 1 << 7)
    
}
