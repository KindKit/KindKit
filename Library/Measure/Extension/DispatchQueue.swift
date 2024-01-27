//
//  KindKit
//

import Dispatch

public extension DispatchQueue {
    
    @inlinable
    func async(
        after time: Time,
        execute item: DispatchWorkItem
    ) {
        self.asyncAfter(
            deadline: .now() + time.timeInterval,
            execute: item
        )
    }

    @inlinable
    func async(
        after time: Time,
        qos: DispatchQoS = .default,
        flags: DispatchWorkItemFlags = [],
        execute block: @escaping @Sendable () -> Void
    ) {
        self.asyncAfter(
            deadline: .now() + time.timeInterval,
            qos: qos,
            flags: flags,
            execute: block
        )
    }
    
}
