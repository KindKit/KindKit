//
//  KindKit
//

import KindGraphics

public protocol ITarget : AnyObject {
    
    func remoteImage(progress: Double)
    func remoteImage(image: Image)
    func remoteImage(error: Error)
    
}

public extension ITarget {
    
    func remoteImage(progress: Double) {
    }
    
}
