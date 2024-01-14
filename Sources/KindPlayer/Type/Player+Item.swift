//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

extension Player {
    
    public enum Item : Equatable {
        
        case url(URL)
        case asset(AVAsset)
        
    }

    
}

#endif
