//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Movie {
    
    struct Context {
        
        let onSuccess: (TemporaryFile) -> Void
        let onFailure: (Error) -> Void
        
    }
    
}
