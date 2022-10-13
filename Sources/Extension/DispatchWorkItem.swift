//
//  KindKit
//

import Foundation

extension DispatchWorkItem : ICancellable {
}

public extension DispatchWorkItem {
    
    static func kk_async(block: @escaping () -> Void, queue: DispatchQueue) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.async(execute: workItem)
        return workItem
    }
    
    static func kk_async(block: @escaping () -> Void, queue: DispatchQueue, delay: TimeInterval) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
    
}
