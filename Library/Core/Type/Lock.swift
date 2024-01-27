//
//  KindKit
//

import Foundation

public final class Lock : LockTrait {
    
    private let _lock: UnsafeMutablePointer< os_unfair_lock >

    public init() {
        self._lock = UnsafeMutablePointer< os_unfair_lock >.allocate(capacity: 1)
        self._lock.initialize(to: os_unfair_lock())
    }

    deinit {
        self._lock.deallocate()
    }
    
    public func perform(_ block: () -> Void) -> Void {
        os_unfair_lock_lock(self._lock)
        defer { os_unfair_lock_unlock(self._lock) }
        block()
    }
    
    public func perform(_ block: () throws -> Void) rethrows -> Void {
        os_unfair_lock_lock(self._lock)
        defer { os_unfair_lock_unlock(self._lock) }
        try block()
    }
    
    public func perform< Return >(_ block: () -> Return) -> Return {
        os_unfair_lock_lock(self._lock)
        defer { os_unfair_lock_unlock(self._lock) }
        return block()
    }
    
    public func perform< Return >(_ block: () throws -> Return) rethrows -> Return {
        os_unfair_lock_lock(self._lock)
        defer { os_unfair_lock_unlock(self._lock) }
        return try block()
    }
    
}

extension Lock : @unchecked Sendable {
}
