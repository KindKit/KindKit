//
//  KindKit
//

import Foundation

public protocol IRemoteImageTarget : AnyObject {
    
    func remoteImage(progress: Double)
    func remoteImage(image: UI.Image)
    func remoteImage(error: RemoteImage.Error)
    
}

public extension IRemoteImageTarget {
    
    func remoteImage(progress: Double) {
    }
    
}
