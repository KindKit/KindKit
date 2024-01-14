//
//  KindKit
//

import AVFoundation
import KindSystem

extension Recorder.Movie {
    
    struct Context {
        
        let config: Config
        let onSuccess: (TemporaryFile) -> Void
        let onFailure: (Error) -> Void
        
    }
    
}
