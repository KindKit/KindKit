//
//  KindKit
//

import KindGraphics

public protocol Target : AnyObject, Sendable {
    
    func remoteImage(progress: Percent)
    func remoteImage(image: Image)
    func remoteImage(error: Error)
    
}

public extension Target {
    
    func remoteImage(progress: Percent) {
    }
    
}
