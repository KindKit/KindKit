//
//  KindKit
//

import Dispatch

public extension DispatchWorkItem {
    
    @inlinable
    static func async< UnitType : IUnit >(
        queue: DispatchQueue = .main,
        delay interval: Interval< UnitType >,
        block: @escaping () -> Void
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: block)
        queue.asyncAfter(after: interval, execute: workItem)
        return workItem
    }
    
}
