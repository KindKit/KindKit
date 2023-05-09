//
//  KindKit
//

import Foundation

final class Lock {
    
    private let _lock: UnsafeMutablePointer< os_unfair_lock >

    public init() {
        self._lock = UnsafeMutablePointer< os_unfair_lock >.allocate(capacity: 1)
        self._lock.initialize(to: os_unfair_lock())
    }

    deinit {
        self._lock.deallocate()
    }

    public func perform< Return >(_ block: () throws -> Return) rethrows -> Return {
        os_unfair_lock_lock(self._lock)
        defer { os_unfair_lock_unlock(self._lock) }
        return try block()
    }
    
}
