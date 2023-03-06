//
//  KindKit
//

import Foundation

extension DispatchWorkItem : ICancellable {
}

public extension DispatchWorkItem {
    
    static func kk_async(
        queue: DispatchQueue = .main,
        block: @escaping () -> Void
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.async(execute: workItem)
        return workItem
    }
    
    static func kk_async(
        queue: DispatchQueue = .main,
        delay: TimeInterval,
        block: @escaping () -> Void
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
    
}
