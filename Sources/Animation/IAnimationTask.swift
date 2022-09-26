//
//  KindKit
//

import Foundation

public protocol IAnimationTask : ICancellable {
    
    var isRunning: Bool { get }
    var isCompletion: Bool { get }
    var isCanceled: Bool { get }
    
}
