//
//  KindKitGraphics
//

import Foundation

public struct GraphicsDrawMode : OptionSet {
    
    public var rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
}

public extension GraphicsDrawMode {
    
    static var fill = GraphicsDrawMode(rawValue: 1 << 0)
    static var stroke = GraphicsDrawMode(rawValue: 1 << 1)
    
}
