//
//  KindKit
//

#if os(macOS) || os(iOS)

import AVFoundation

public enum Item : Equatable {
    
    case url(URL)
    case asset(AVAsset)
    
}

#endif
