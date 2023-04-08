//
//  KindKit
//

import UIKit

public extension Manager.DisablingLockScreen {
    
    final class Real : IDisablingLockScreenManager {
        
        private var _counter: UInt
        
        public init() {
            self._counter = 0
        }
        
        deinit {
            self.stop()
        }
        
        public func start() {
            self._counter += 1
            if self._counter == 1 {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        
        public func stop() {
            if self._counter == 0 {
                return
            }
            self._counter -= 1
            if self._counter == 0 {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        
    }
    
}

public extension IDisablingLockScreenManager where Self == Manager.DisablingLockScreen.Real {
    
    static func real() -> Self {
        return .init()
    }
    
}
