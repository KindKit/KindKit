//
//  KindKit
//

import AVFoundation

public extension PhotoRecorder {
    
    enum Error : Swift.Error {
        
        case notConneted
        case imageRepresentation
        case `internal`(Swift.Error)
        
    }
    
}
