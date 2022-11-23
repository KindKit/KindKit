//
//  KindKit
//

import Foundation
import AVFoundation

extension CameraSession.Recorder.Photo {
    
    struct Context {
        
        let onSuccess: (UI.Image) -> Void
        let onFailure: (Error) -> Void
        
    }
    
}
