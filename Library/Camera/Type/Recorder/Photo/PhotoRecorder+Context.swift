//
//  KindKit
//

import AVFoundation
import KindGraphics

extension PhotoRecorder {
    
    struct Context {
        
        let config: Config
        let onSuccess: @Sendable (Image) -> Void
        let onFailure: @Sendable (Error) -> Void
        
    }
    
}
