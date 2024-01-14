//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

extension Player {
    
    public struct Options : OptionSet {
        
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
    }

    
}

public extension Player.Options {
    
    static let autoplay = Player.Options(rawValue: 1 << 0)
    static let autorepeat = Player.Options(rawValue: 1 << 1)
    
}

#endif
