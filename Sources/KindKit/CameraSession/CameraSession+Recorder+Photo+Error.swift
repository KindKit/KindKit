//
//  KindKit
//

import Foundation
import AVFoundation

public extension CameraSession.Recorder.Photo {
    
    enum Error : Swift.Error {
        
        case notConneted
        case imageRepresentation
        case `internal`(Swift.Error)
        
    }
    
}
