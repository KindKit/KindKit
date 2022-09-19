//
//  KindKit
//

import Foundation

public protocol IAnimationTask {
    
    var isRunning: Bool { get }
    var isCompletion: Bool { get }
    var isCanceled: Bool { get }
    
    func cancel()
    
}
