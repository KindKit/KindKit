//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindCore

public final class LockScreenManager {
    
    private let _lock = Lock()
    private var _counter: UInt
#if os(macOS)
    private var _activity: NSObjectProtocol?
#endif
    
    public init() {
        self._counter = 0
    }
    
    public func start() {
        self._lock.perform({
            self._counter += 1
            if self._counter == 1 {
#if os(macOS)
                self._activity = ProcessInfo.processInfo.beginActivity(reason: "Lock screen")
#elseif os(iOS)
                Task(operation: {
                    await MainActor.run(body: {
                        UIApplication.shared.isIdleTimerDisabled = true
                    })
                })
#endif
            }
        })
    }
    
    public func stop() {
        self._lock.perform({
            if self._counter == 0 {
                return
            }
            self._counter -= 1
            if self._counter == 0 {
#if os(macOS)
                if let activity = self._activity {
                    self._activity = nil
                    ProcessInfo.processInfo.endActivity(activity)
                }
#elseif os(iOS)
                Task(operation: {
                    await MainActor.run(body: {
                        UIApplication.shared.isIdleTimerDisabled = false
                    })
                })
#endif
            }
        })
    }
    
}

extension LockScreenManager : @unchecked Sendable {
}

