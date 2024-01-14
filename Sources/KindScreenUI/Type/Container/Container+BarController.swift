//
//  KindKit
//

import KindAnimation
import KindEvent

public protocol IContainerBarControllerObserver : AnyObject {
    
    func changed(_ barController: Container.BarController)
    
}
public extension Container {
    
    final class BarController {
        
        public var isAnimating: Bool {
            return self._animation != nil
        }
        
        private var _visibility: [Target : Double]
        private var _observer = Observer< IContainerBarControllerObserver >()
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            visibility: [Target : Double] = [:]
        ) {
            self._visibility = visibility
            for target in Target.allCases {
                guard self._visibility[target] == nil else { continue }
                self._visibility[target] = 1
            }
        }
        
        deinit {
            self._destroy()
        }
        
    }
    
}

public extension Container.BarController {
    
    static let shared = Container.BarController()
    
}

public extension Container.BarController {
    
    func add(observer: IContainerBarControllerObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    func remove(observer: IContainerBarControllerObserver) {
        self._observer.remove(observer)
    }
    
    func set(_ target: Target, visibility: Double) {
        self._visibility[target] = visibility
        self._notify()
    }
    
    func visibility(_ target: Target) -> Double {
        guard let visibility = self._visibility[target] else { return 0 }
        return visibility
    }
    
    func hidden(_ target: Target) -> Bool {
        return self.visibility(target) == 0
    }
    
    func animate(
        duration: TimeInterval,
        ease: KindAnimation.IEase = KindAnimation.Ease.QuadraticInOut(),
        visibility: [Target : Double],
        completion: (() -> Void)? = nil
    ) {
        guard self.isAnimating == false else { return }
        let beginVisibility = self._visibility
        self._animation = KindAnimation.default.run(
            .custom(
                duration: duration,
                ease: ease,
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    for new in visibility {
                        guard let begin = beginVisibility[new.key] else { continue }
                        self._visibility[new.key] = begin.lerp(new.value, progress: progress)
                    }
                    self._notify()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._animation = nil
                    for new in visibility {
                        self._visibility[new.key] = new.value
                    }
                    self._notify()
                }
            )
        )
    }
    
}

private extension Container.BarController {
    
    func _destroy() {
        self._animation = nil
    }
    
    func _notify() {
        self._observer.emit({ $0.changed(self) })
    }
    
}
