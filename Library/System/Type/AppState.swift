//
//  KindKit
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindEvent
import KindMonadicMacro

@Monadic
public final class AppState : @unchecked Sendable {
    
    @MonadicSignal
    public let onBecomeActive = Signal< Void, Void >()
    
    @MonadicSignal
    public let onResignActive = Signal< Void, Void >()
    
    @MonadicSignal
    public let onEnterForeground = Signal< Void, Void >()
    
    @MonadicSignal
    public let onEnterBackground = Signal< Void, Void >()
    
    @MonadicSignal
    public let onMemoryWarning = Signal< Void, Void >()
    
    private var _active: Bool?
    
#if os(iOS)
    private var _becomeActiveObserver: NSObjectProtocol?
    private var _resignActiveObserver: NSObjectProtocol?
    private var _enterForegroundObserver: NSObjectProtocol?
    private var _enterBackgroundObserver: NSObjectProtocol?
    private var _memoryWarningObserver: NSObjectProtocol?
#endif
    
    fileprivate init() {
#if os(iOS)
        self._becomeActiveObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] in self?._didBecomeActive($0) }
        )
        self._resignActiveObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] in self?._didResignActive($0) }
        )
        self._enterForegroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] in self?._didEnterBackground($0) }
        )
        self._enterBackgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] in self?._didEnterForeground($0) }
        )
        self._memoryWarningObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] in self?._didMemoryWarning($0) }
        )
#endif
    }
    
    deinit {
#if os(iOS)
        if let observer = self._becomeActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self._resignActiveObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self._enterForegroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self._enterBackgroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = self._memoryWarningObserver {
            NotificationCenter.default.removeObserver(observer)
        }
#endif
    }
    
}

public extension AppState {
    
    static let `default` = AppState()
    
}

private extension AppState {
    
    func _didBecomeActive(_ notification: Notification) {
        guard self._active == false else { return }
        self._active = true
        self.onBecomeActive.emit()
    }
    
    func _didResignActive(_ notification: Notification) {
        self._active = false
        self.onResignActive.emit()
    }
    
    func _didEnterForeground(_ notification: Notification) {
        self.onEnterForeground.emit()
    }
    
    func _didEnterBackground(_ notification: Notification) {
        self.onEnterBackground.emit()
    }
    
    func _didMemoryWarning(_ notification: Notification) {
        self.onMemoryWarning.emit()
    }
    
}
