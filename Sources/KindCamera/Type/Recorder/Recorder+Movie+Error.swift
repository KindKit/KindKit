//
//  KindKit
//

import AVFoundation

public extension Recorder.Movie {
    
    enum Error : Swift.Error {
        
        case notConneted
        case `internal`(Swift.Error)
        
    }
    
}
