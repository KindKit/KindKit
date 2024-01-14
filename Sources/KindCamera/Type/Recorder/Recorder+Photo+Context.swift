//
//  KindKit
//

import AVFoundation
import KindGraphics

extension Recorder.Photo {
    
    struct Context {
        
        let config: Config
        let onSuccess: (Image) -> Void
        let onFailure: (Error) -> Void
        
    }
    
}
