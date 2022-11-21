//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Animation {
    
    final class DisplayLink : NSObject {
        
        weak var delegate: IAnimationQueueDelegate?
        
        var isRunning: Bool {
            return self._instance != nil
        }
        
        private var _instance: CADisplayLink?
        private var _prevTime: CFTimeInterval!
        
        func start() {
            if self._instance == nil {
                let instance = CADisplayLink(target: self, selector: #selector(self._handle))
                instance.add(to: .main, forMode: .common)
                self._instance = instance
                self._prevTime = CACurrentMediaTime()
            }
        }
        
        func stop() {
            if let instance = self._instance {
                instance.remove(from: .main, forMode: .common)
                instance.isPaused = true
                instance.invalidate()
            }
            self._instance = nil
        }
        
    }
    
}

#if targetEnvironment(simulator)

@_silgen_name("UIAnimationDragCoefficient")
func UIAnimationDragCoefficient() -> Float

#endif

private extension Animation.DisplayLink {
    
    @objc
    func _handle() {
        let now = CACurrentMediaTime()
#if targetEnvironment(simulator)
        let delta = (now - self._prevTime) / CFTimeInterval(UIAnimationDragCoefficient())
#else
        let delta = now - self._prevTime
#endif
        self._prevTime = now
        self.delegate?.update(TimeInterval(delta))
    }
    
}

#endif
