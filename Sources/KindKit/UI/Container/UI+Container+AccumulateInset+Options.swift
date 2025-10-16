//
//  KindKit
//

import Foundation

public extension UI.Container.InheritedInset {

    struct Options : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }

}

public extension UI.Container.InheritedInset.Options {
    
    static let device = Self(rawValue: 1 << 0)
    static let virtualKeyboard = Self(rawValue: 1 << 1)
    static let contentStatic = Self(rawValue: 1 << 2)
    static let contentInteractive = Self(rawValue: 1 << 3)
    
}
