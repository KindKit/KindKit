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
    
    static func async(block: @escaping () -> Void, queue: DispatchQueue, after: DispatchTime) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(deadline: after, execute: workItem)
        return workItem
    }
    
}

extension DispatchWorkItem : ICancellable {
}
