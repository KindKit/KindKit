//
//  KindKit
//

import Foundation

public protocol ScrollViewHidingBarExtensionObserver : AnyObject {
    
    func changed(scrollViewExtension: UI.View.Scroll.Extension.HidingBar)
    
}

public extension UI.View.Scroll.Extension {
    
    final class HidingBar {
        
        public var direction: Direction
        public var state: State
        public var visibility: PercentFloat {
            switch self.state {
            case .showed: return .one
            case .showing(let progress): return progress
            case .hiding(let progress): return progress.invert
            case .hided: return .zero
            }
        }
        public var threshold: Float
        public var animationVelocity: Float
        public var isAnimating: Bool {
            return self._animation != nil
        }
        public var scrollView: UI.View.Scroll {
            willSet { self.scrollView.remove(observer: self) }
            didSet { self.scrollView.add(observer: self) }
        }
        
        private var _anchor: Float?
        private var _observer: Observer< ScrollViewHidingBarExtensionObserver >
        private var _animation: IAnimationTask?
        
        public init(
            direction: Direction = .vertical,
            state: State = .showed,
            threshold: Float = 100,
            animationVelocity: Float = 600,
            scrollView: UI.View.Scroll
        ) {
            self.direction = direction
            self.state = state
            self.threshold = threshold
            self.animationVelocity = animationVelocity
            self.scrollView = scrollView
            self._observer = Observer()
            self.scrollView.add(observer: self)
        }
        
        deinit {
            self.scrollView.remove(observer: self)
        }

    }
    
}

public extension UI.View.Scroll.Extension.HidingBar {
    
    enum Direction {
        
        case horizontal
        case vertical
        
    }
    
    enum State : Equatable {
        
        case showed
        case showing(progress: PercentFloat)
        case hiding(progress: PercentFloat)
        case hided
        
    }
    
}

public extension UI.View.Scroll.Extension.HidingBar {
    
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

extension UI.View.Scroll.Extension.HidingBar : IUIScrollViewObserver {
    
    public func beginScrolling(scrollView: UI.View.Scroll) {
    }
    
    public func scrolling(scrollView: UI.View.Scroll) {
        guard self._animation == nil else { return }
        let visible: Float
        let offset: Float
        let size: Float
        switch self.direction {
        case .horizontal:
            visible = scrollView.bounds.width
            offset = scrollView.contentOffset.x + scrollView.contentInset.left
            size = scrollView.contentInset.left + scrollView.contentSize.width + scrollView.contentInset.right
        case .vertical:
            visible = scrollView.bounds.height
            offset = scrollView.contentOffset.y + scrollView.contentInset.top
            size = scrollView.contentInset.top + scrollView.contentSize.height + scrollView.contentInset.bottom
        }
        if size > visible {
            let anchor: Float
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
    
    public func endScrolling(scrollView: UI.View.Scroll, decelerate: Bool) {
        if decelerate == false {
            self._end()
        }
    }
    
    public func beginDecelerating(scrollView: UI.View.Scroll) {
    }
    
    public func endDecelerating(scrollView: UI.View.Scroll) {
        self._end()
    }
    
    public func scrollToTop(scrollView: UI.View.Scroll) {
        self._end(forceShow: false)
    }
    
}

private extension UI.View.Scroll.Extension.HidingBar {
    
    @inline(__always)
    func _end() {
        let offset: Float
        switch self.direction {
        case .horizontal: offset = scrollView.contentOffset.x + scrollView.contentInset.left
        case .vertical: offset = scrollView.contentOffset.y + scrollView.contentInset.top
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
                self._animation = Animation.default.run(
                    duration: TimeInterval(self.threshold / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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
            }
        case .showing(let baseProgress):
            if baseProgress >= .half || forceShow == true {
                self._animation = Animation.default.run(
                    duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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
            } else {
                self._animation = Animation.default.run(
                    duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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
            }
        case .hiding(let baseProgress):
            if baseProgress <= .half || forceShow == true {
                self._animation = Animation.default.run(
                    duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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
            } else {
                self._animation = Animation.default.run(
                    duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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
            }
        }
    }
    
    @inline(__always)
    func _set(isShowed: Bool, animate: Bool, completion: (() -> Void)?) {
        if animate == true {
            switch self.state {
            case .showed:
                if isShowed == false {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self.threshold / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                } else {
                    completion?()
                }
            case .hided:
                if isShowed == true {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self.threshold / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                } else {
                    completion?()
                }
            case .showing(let baseProgress):
                if isShowed == true {
                    self._animation = Animation.default.run(
                        duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                } else {
                    self._animation = Animation.default.run(
                        duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                }
            case .hiding(let baseProgress):
                if isShowed == true {
                    self._animation = Animation.default.run(
                        duration: TimeInterval((self.threshold * baseProgress.value) / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                } else {
                    self._animation = Animation.default.run(
                        duration: TimeInterval((self.threshold * baseProgress.invert.value) / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
            self._observer.notify({ $0.changed(scrollViewExtension: self) })
        }
    }
    
    @inline(__always)
    static func _visibility(
        state: State,
        threshold: Float,
        visible: Float,
        anchor: Float,
        offset: Float,
        size: Float
    ) -> State {
        let delta: Float
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
                return .hiding(progress: Percent(-delta / threshold))
            }
            return .showed
        case .showing:
            if delta > 0 {
                if delta > threshold {
                    return .showed
                }
                return .showing(progress: Percent(delta / threshold))
            }
            return .hided
        case .hiding:
            if delta < 0 {
                if delta < -threshold {
                    return .hided
                }
                return .hiding(progress: Percent(-delta / threshold))
            }
            return .showed
        case .hided:
            if delta > 0 {
                if delta > threshold {
                    return .showed
                }
                return .showing(progress: Percent(delta / threshold))
            }
            return .hided
        }
    }
    
}
