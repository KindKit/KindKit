//
//  KindKit
//

import AVFoundation

public extension Recorder.Photo {
    
    enum Error : Swift.Error {
        
        case notConneted
        case imageRepresentation
        case `internal`(Swift.Error)
        
    }
    
}
