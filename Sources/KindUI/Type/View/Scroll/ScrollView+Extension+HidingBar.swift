//
//  KindKit
//

import KindAnimation
import KindMath
import KindEvent

public protocol ScrollViewHidingBarExtensionObserver : AnyObject {
    
    func changed(hidingBar: ScrollView.Extension.HidingBar)
    
}

public extension ScrollView.Extension {
    
    final class HidingBar {
        
        public var direction: Direction
        public var state: State
        public var visibility: Percent {
            switch self.state {
            case .showed: return .one
            case .showing(let progress): return progress
            case .hiding(let progress): return progress.invert
            case .hided: return .zero
            }
        }
        public var threshold: Double
        public var animationVelocity: Double
        public var isAnimating: Bool {
            return self._animation != nil
        }
        public var scroll: ScrollView {
            willSet { self.scroll.remove(observer: self) }
            didSet { self.scroll.add(observer: self) }
        }
        
        private var _anchor: Double?
        private var _observer = Observer< ScrollViewHidingBarExtensionObserver >()
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            direction: Direction = .vertical,
            state: State = .showed,
            threshold: Double = 100,
            animationVelocity: Double = 600,
            scroll: ScrollView
        ) {
            self.direction = direction
            self.state = state
            self.threshold = threshold
            self.animationVelocity = animationVelocity
            self.scroll = scroll
            self._setup()
        }
        
        deinit {
            self._destroy()
        }

    }
    
}

public extension ScrollView.Extension.HidingBar {
    
    enum Direction {
        
        case horizontal
        case vertical
        
    }
    
    enum State : Equatable {
        
        case showed
        case showing(progress: Percent)
        case hiding(progress: Percent)
        case hided
        
    }
    
}

public extension ScrollView.Extension.HidingBar {
    
    func add(observer: ScrollViewHidingBarExtensionObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    func remove(observer: ScrollViewHidingBarExtensionObserver) {
        self._observer.remove(observer)
    }
    
    func reset(animate: Bool, completion: (() -> Void)? = nil) {
        self._anchor = nil
        self._set(isShowed: true, animate: animate, completion: completion)
    }
    
}

extension ScrollView.Extension.HidingBar : IScrollViewObserver {
    
    public func beginDragging(scroll: ScrollView) {
    }
    
    public func dragging(scroll: ScrollView) {
        guard self._animation == nil else { return }
        let visible: Double
        let offset: Double
        let size: Double
        switch self.direction {
        case .horizontal:
            visible = scroll.bounds.width
            offset = scroll.contentOffset.x + scroll.contentInset.left
            size = scroll.contentInset.left + scroll.contentSize.width + scroll.contentInset.right
        case .vertical:
            visible = scroll.bounds.height
            offset = scroll.contentOffset.y + scroll.contentInset.top
            size = scroll.contentInset.top + scroll.contentSize.height + scroll.contentInset.bottom
        }
        if size > visible {
            let anchor: Double
            if let existAnchor = self._anchor {
                anchor = existAnchor
            } else {
                self._anchor = offset
                anchor = offset
            }
            let newState = Self._visibility(
                state: self.state,
                threshold: self.threshold,
                visible: visible,
                anchor: anchor,
                offset: offset,
                size: size
            )
            if newState == .showed || newState == .hided {
                self._anchor = max(0, offset)
            }
            self._set(state: newState)
        }
    }
    
    public func endDragging(scroll: ScrollView, decelerate: Bool) {
        if decelerate == false {
            self._end()
        }
    }
    
    public func beginDecelerating(scroll: ScrollView) {
    }
    
    public func endDecelerating(scroll: ScrollView) {
        self._end()
    }
    
    public func beginZooming(scroll: ScrollView) {
    }
    
    public func zooming(scroll: ScrollView) {
    }
    
    public func endZooming(scroll: ScrollView) {
    }
    
    public func scrollToTop(scroll: ScrollView) {
        self._end(forceShow: false)
    }
    
}

private extension ScrollView.Extension.HidingBar {
    
    func _setup() {
        self.scroll.add(observer: self)
    }

    func _destroy() {
        self.scroll.remove(observer: self)
        self._animation = nil
    }
    
    @inline(__always)
    func _end() {
        let offset: Double
        switch self.direction {
        case .horizontal: offset = scroll.contentOffset.x + scroll.contentInset.left
        case .vertical: offset = scroll.contentOffset.y + scroll.contentInset.top
        }
        self._end(forceShow: offset < self.threshold)
    }
    
    @inline(__always)
    func _end(forceShow: Bool) {
        self._anchor = nil
        switch self.state {
        case .showed:
            break
        case .hided:
            if forceShow == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self.threshold / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._set(state: .showing(progress: progress))
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._set(state: .showed)
                        }
                    )
                )
            }
        case .showing(let baseProgress):
            if baseProgress >= .half || forceShow == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._set(state: .showing(progress: baseProgress + (baseProgress.invert * progress)))
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._set(state: .showed)
                        }
                    )
                )
            } else {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._set(state: .showing(progress: baseProgress - (baseProgress * progress)))
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._set(state: .hided)
                        }
                    )
                )
            }
        case .hiding(let baseProgress):
            if baseProgress <= .half || forceShow == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._set(state: .hiding(progress: baseProgress - (baseProgress * progress)))
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._set(state: .showed)
                        }
                    )
                )
            } else {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._set(state: .hiding(progress: baseProgress + (baseProgress.invert * progress)))
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._set(state: .hided)
                        }
                    )
                )
            }
        }
    }
    
    @inline(__always)
    func _set(isShowed: Bool, animate: Bool, completion: (() -> Void)?) {
        if animate == true {
            switch self.state {
            case .showed:
                if isShowed == false {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.threshold / self.animationVelocity),
                            ease: KindAnimation.Ease.QuadraticInOut(),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._set(state: .hiding(progress:  progress))
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._animation = nil
                                self._set(state: .hided)
                                completion?()
                            }
                        )
                    )
                } else {
                    completion?()
                }
            case .hided:
                if isShowed == true {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.threshold / self.animationVelocity),
                            ease: KindAnimation.Ease.QuadraticInOut(),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._set(state: .showing(progress: progress))
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._animation = nil
                                self._set(state: .showed)
                                completion?()
                            }
                        )
                    )
                } else {
                    completion?()
                }
            case .showing(let baseProgress):
                if isShowed == true {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                            ease: KindAnimation.Ease.QuadraticInOut(),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._set(state: .showing(progress: baseProgress + (baseProgress.invert * progress)))
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._animation = nil
                                self._set(state: .showed)
                                completion?()
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                            ease: KindAnimation.Ease.QuadraticInOut(),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._set(state: .showing(progress: baseProgress - (baseProgress * progress)))
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._animation = nil
                                self._set(state: .hided)
                                completion?()
                            }
                        )
                    )
                }
            case .hiding(let baseProgress):
                if isShowed == true {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                            ease: KindAnimation.Ease.QuadraticInOut(),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._set(state: .hiding(progress: baseProgress - (baseProgress * progress)))
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._animation = nil
                                self._set(state: .showed)
                                completion?()
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                            ease: KindAnimation.Ease.QuadraticInOut(),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._set(state: .hiding(progress: baseProgress + (baseProgress.invert * progress)))
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._animation = nil
                                self._set(state: .hided)
                                completion?()
                            }
                        )
                    )
                }
            }
        } else {
            self._set(state: isShowed == true ? .showed : .hided)
            completion?()
        }
    }
    
    @inline(__always)
    func _set(state: State) {
        if self.state != state {
            self.state = state
            self._observer.emit({ $0.changed(hidingBar: self) })
        }
    }
    
    @inline(__always)
    static func _visibility(
        state: State,
        threshold: Double,
        visible: Double,
        anchor: Double,
        offset: Double,
        size: Double
    ) -> State {
        let delta: Double
        if offset > threshold / 2 {
            delta = anchor - offset
        } else {
            delta = 0
        }
        switch state {
        case .showed:
            if delta < 0 {
                if delta < -threshold {
                    return .hided
                }
                return .hiding(progress: Percent(-delta, from: threshold))
            }
            return .showed
        case .showing:
            if delta > 0 {
                if delta > threshold {
                    return .showed
                }
                return .showing(progress: Percent(delta, from: threshold))
            }
            return .hided
        case .hiding:
            if delta < 0 {
                if delta < -threshold {
                    return .hided
                }
                return .hiding(progress: Percent(-delta, from: threshold))
            }
            return .showed
        case .hided:
            if delta > 0 {
                if delta > threshold {
                    return .showed
                }
                return .showing(progress: Percent(delta, from: threshold))
            }
            return .hided
        }
    }
    
}
