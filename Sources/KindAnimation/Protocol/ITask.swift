//
//  KindKit
//

import Foundation

public protocol ITask : ICancellable {
    
    var isRunning: Bool { get }
    var isCompletion: Bool { get }
    var isCanceled: Bool { get }
    
    func update(_ delta: TimeInterval) -> Bool
    func complete()
    
}
