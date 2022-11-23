//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition.ZStack {
    
    struct Mode : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let horizontal = Mode(rawValue: 1 << 0)
        public static let vertical = Mode(rawValue: 1 << 1)
        
    }
    
}
