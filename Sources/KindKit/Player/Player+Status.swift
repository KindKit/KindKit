//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

extension Player {
    
    public enum Status : Equatable {
        
        case idle
        case load
        case ready
        case play
        case pause
        case finish
        case error(Player.Error)
        
    }

    
}

#endif
