//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Photo {
    
    struct Context {
        
        let config: Config
        let onSuccess: (UI.Image) -> Void
        let onFailure: (Error) -> Void
        
    }
    
}
