//
//  KindKit
//

import Foundation

public extension Graphics {

    struct DrawMode : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension Graphics.DrawMode {
    
    static let fill = Graphics.DrawMode(rawValue: 1 << 0)
    static let stroke = Graphics.DrawMode(rawValue: 1 << 1)
    
}
