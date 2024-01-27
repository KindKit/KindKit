//
//  KindKit
//

import Dispatch

public extension DispatchQueue {
    
    @inlinable
    func asyncAfter< UnitType : IUnit >(
        after interval: Interval< UnitType >,
        execute item: DispatchWorkItem
    ) {
        self.asyncAfter(deadline: .now() + interval.timeInterval, execute: item)
    }

    @inlinable
    func asyncAfter< UnitType : IUnit >(
        after interval: Interval< UnitType >,
        qos: DispatchQoS = .default,
        flags: DispatchWorkItemFlags = [],
        execute block: @escaping () -> Void
    ) {
        self.asyncAfter(deadline: .now() + interval.timeInterval, qos: qos, flags: flags, execute: block)
    }
    
}
