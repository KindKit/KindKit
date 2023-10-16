//
//  KindKit
//

import AVFoundation

extension CameraSession.Recorder.Movie {
    
    struct Context {
        
        let onSuccess: (URL) -> Void
        let onFailure: (Error) -> Void
        
    }
    
}
