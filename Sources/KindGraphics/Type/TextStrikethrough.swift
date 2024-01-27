//
//  KindKit
//

public struct TextStrikethrough : OptionSet, Hashable {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension TextStrikethrough {
    
    static var single = Self(rawValue: 1 << 0)
    static var thick = Self(rawValue: 1 << 1)
    static var double = Self(rawValue: 1 << 2)
    static var patternDot = Self(rawValue: 1 << 3)
    static var patternDash = Self(rawValue: 1 << 4)
    static var patternDashDot = Self(rawValue: 1 << 5)
    static var patternDashDotDot = Self(rawValue: 1 << 6)
    static var byWord = Self(rawValue: 1 << 7)

}
