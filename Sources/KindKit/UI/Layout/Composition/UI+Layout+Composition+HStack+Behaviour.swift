//
//  KindKit
//

import Foundation

public extension UI.Layout.Composition.HStack {
    
    struct Behaviour : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension UI.Layout.Composition.HStack.Behaviour {
    
    static let fit = Self(rawValue: 1 << 0)
    
}
