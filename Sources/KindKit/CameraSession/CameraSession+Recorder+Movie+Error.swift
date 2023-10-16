//
//  KindKit
//

import AVFoundation

public extension CameraSession.Recorder.Movie {
    
    enum Error : Swift.Error {
        
        case notConneted
        case `internal`(Swift.Error)
        
    }
    
}
