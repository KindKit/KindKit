//
//  KindKit
//

import Foundation

public protocol IRemoteImageTarget : AnyObject {
    
    func remoteImage(progress: Float)
    func remoteImage(image: Image)
    func remoteImage(error: Error)
    
}
