//
//  KindKit
//

public struct DrawMode : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension DrawMode {
    
    static let fill = DrawMode(rawValue: 1 << 0)
    static let stroke = DrawMode(rawValue: 1 << 1)
    
}
