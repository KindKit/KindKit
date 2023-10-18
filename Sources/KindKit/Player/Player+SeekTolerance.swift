//
//  KindKit
//

#if os(macOS) || os(iOS)

import CoreMedia
import AVFoundation

extension Player {
    
    public struct SeekTolerance : Equatable {
        
        public let before: CMTime
        public let after: CMTime
        
        public init(
            before: CMTime = .init(seconds: 0, preferredTimescale: .init(NSEC_PER_SEC)),
            after: CMTime = .init(seconds: 0, preferredTimescale: .init(NSEC_PER_SEC))
        ) {
            self.before = before
            self.after = after
        }
        
    }

    
}

#endif
