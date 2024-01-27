//
//  KindKit
//

import Foundation

extension DispatchWorkItem : ICancellable {
}

public extension DispatchWorkItem {
    
    @inlinable
    static func async(
        queue: DispatchQueue = .main,
        block: @escaping () -> Void
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.async(execute: workItem)
        return workItem
    }
    
}
