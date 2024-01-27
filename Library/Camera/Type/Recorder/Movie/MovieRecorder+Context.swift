//
//  KindKit
//

import AVFoundation
import KindSystem

extension MovieRecorder {
    
    struct Context {
        
        let config: Config
        let onSuccess: @Sendable (TemporaryFile) -> Void
        let onFailure: @Sendable (Error) -> Void
        
    }
    
}

extension MovieRecorder.Context : Sendable {
}
