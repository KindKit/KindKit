//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IAnimationEase {
    
    func perform(_ x: Float) -> Float
    
}

public protocol IAnimationTask {
    
    var isRunning: Bool { get }
    var isCompletion: Bool { get }
    var isCanceled: Bool { get }
    
    func cancel()
    
}
