//
//  KindKitCore
//

import Foundation

public extension DispatchWorkItem {
    
    static func async(block: @escaping () -> Void, queue: DispatchQueue) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.async(execute: workItem)
        return workItem
    }
    
    static func async(block: @escaping () -> Void, queue: DispatchQueue, delay: TimeInterval) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(deadline: .now() + delay, execute: block)
        return workItem
    }
    
}

extension DispatchWorkItem : ICancellable {
}
