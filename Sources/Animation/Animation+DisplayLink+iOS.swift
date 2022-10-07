//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Animation {
    
    final class DisplayLink : NSObject {
        
        unowned var delegate: IAnimationQueueDelegate?
        
        var isRunning: Bool {
            return self._displayLink != nil
        }
        
        private var _displayLink: CADisplayLink?
        private var _prevTime: CFTimeInterval!
        
        func start() {
            if self._displayLink == nil {
                let displayLink = CADisplayLink(target: self, selector: #selector(self._handle))
                displayLink.add(to: .main, forMode: .common)
                self._displayLink = displayLink
                self._prevTime = CACurrentMediaTime()
            }
        }
        
        func stop() {
            if let displayLink = self._displayLink {
                displayLink.remove(from: .main, forMode: .common)
                displayLink.isPaused = true
                displayLink.invalidate()
            }
            self._displayLink = nil
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
