//
//  KindKit
//

import Dispatch

public extension DispatchWorkItem {
    
    @inlinable
    static func async(
        queue: DispatchQueue = .main,
        delay time: Time,
        block: @escaping () -> Void
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.async(after: time, execute: workItem)
        return workItem
    }
    
}
