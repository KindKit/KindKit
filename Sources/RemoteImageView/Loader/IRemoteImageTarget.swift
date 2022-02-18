//
//  KindKitRemoteImageView
//

import Foundation
import KindKitCore
import KindKitView

public protocol IRemoteImageTarget : AnyObject {
    
    func remoteImage(progress: Float)
    func remoteImage(image: Image)
    func remoteImage(error: Error)
    
}
