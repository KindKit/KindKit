//
//  KindKit
//

import Foundation

public final class RecursiveLock : LockTrait {
    
    private let _lock: UnsafeMutablePointer< os_unfair_lock >

    public init() {
        self._lock = UnsafeMutablePointer< os_unfair_lock >.allocate(capacity: 1)
        self._lock.initialize(to: os_unfair_lock())
    }

    deinit {
        self._lock.deallocate()
    }
    
    public func perform(_ block: () -> Void) -> Void {
        if os_unfair_lock_trylock(self._lock) == true {
            defer { os_unfair_lock_unlock(self._lock) }
            block()
        } else {
            block()
        }
    }
    
    public func perform(_ block: () throws -> Void) rethrows -> Void {
        if os_unfair_lock_trylock(self._lock) == true {
            defer { os_unfair_lock_unlock(self._lock) }
            try block()
        } else {
            try block()
        }
    }
    
    public func perform< Return >(_ block: () -> Return) -> Return {
        if os_unfair_lock_trylock(self._lock) == true {
            defer { os_unfair_lock_unlock(self._lock) }
            return block()
        } else {
            return block()
        }
    }
    
    public func perform< Return >(_ block: () throws -> Return) rethrows -> Return {
        if os_unfair_lock_trylock(self._lock) == true {
            defer { os_unfair_lock_unlock(self._lock) }
            return try block()
        } else {
            return try block()
        }
    }
    
}

extension RecursiveLock : @unchecked Sendable {
}
