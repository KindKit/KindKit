//
//  KindKitView
//

import Foundation
import KindKitCore

public protocol IAnimationTask {
    
    var isRunning: Bool { get }
    var isCompletion: Bool { get }
    var isCanceled: Bool { get }
    
    func cancel()
    
}
