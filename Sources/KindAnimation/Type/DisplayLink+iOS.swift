//
//  KindKit
//

#if os(iOS)

import UIKit

final class DisplayLink : NSObject {
    
    let manager: Manager
    var prevTime: CFTimeInterval
    var instance: CADisplayLink!
    
    init(manager: Manager) {
        self.manager = manager
        self.prevTime = CACurrentMediaTime()
        
        super.init()
        
        self.instance = CADisplayLink(target: self, selector: #selector(self._handle))
        self.instance.add(to: .main, forMode: .common)
    }
    
    deinit {
        self.instance.remove(from: .main, forMode: .common)
        self.instance.isPaused = true
        self.instance.invalidate()
    }
    
}

#if targetEnvironment(simulator) && swift(<5.10)

@_silgen_name("UIDragCoefficient")
func UIDragCoefficient() -> Float

#endif

private extension DisplayLink {
    
    @objc
    func _handle() {
        let now = CACurrentMediaTime()
#if targetEnvironment(simulator) && swift(<5.10)
        let delta = (now - self.prevTime) / CFTimeInterval(UIDragCoefficient())
#else
        let delta = now - self.prevTime
#endif
        self.prevTime = now
        self.manager.update(.init(delta))
    }
    
}

#endif
