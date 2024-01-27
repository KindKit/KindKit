//
//  KindKit
//

import KindAnimation
import KindUI
import KindTimer

public extension Container {
    
    final class Push : IPushContainer {
        
        public weak var parent: IContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.refreshParentInset()
#if os(iOS)
                        self.orientation = parent.orientation
#endif
                    }
                } else {
                    self.refreshParentInset()
#if os(iOS)
                    self.orientation = .unknown
#endif
                }
            }
        }
        public var shouldInteractive: Bool {
            return self.content?.shouldInteractive ?? false
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            guard let current = self._current else {
                return self.content?.statusBar ?? .default
            }
            return current.container.statusBar
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            guard let current = self._current else {
                return self.content?.statusBarAnimation ?? .fade
            }
            return current.container.statusBarAnimation
        }
        public var statusBarHidden: Bool {
            guard let current = self._current else {
                return self.content?.statusBarHidden ?? false
            }
            return current.container.statusBarHidden
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            guard let current = self._current else {
                return self.content?.supportedOrientations ?? .all
            }
            return current.container.supportedOrientations
        }
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                for item in self._items {
                    item.container.didChange(orientation: self.orientation)
                }
                self.content?.didChange(orientation: self.orientation)
            }
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IView {
            return self._view
        }
        public var inset: Inset {
            set {
                guard self._layout.inset != newValue else { return }
                self._layout.inset = newValue
                for item in self._items {
                    item.update(
                        self._view.bounds.size,
                        newValue + self._layout.parentInset,
                        newValue + self._layout.contentInset
                    )
                }
            }
            get { self._layout.inset }
        }
        public var content: (IContainer & IContainerParentable)? {
            willSet {
                if let content = self.content {
                    if self.isPresented == true {
                        content.prepareHide(interactive: false)
                        content.finishHide(interactive: false)
                    }
                    content.parent = nil
                }
            }
            didSet {
                self._layout.content = self.content?.view
                if let content = self.content {
                    content.parent = self
                    if self.isPresented == true {
                        content.prepareShow(interactive: false)
                        content.finishShow(interactive: false)
                    }
                }
                if self.isPresented == true {
#if os(iOS)
                    self.refreshOrientations()
                    self.refreshStatusBar()
#endif
                }
            }
        }
        public var containers: [IPushContentContainer] {
            return self._items.map({ return $0.container })
        }
        public var previous: IPushContentContainer? {
            return self._previous?.container
        }
        public var current: IPushContentContainer? {
            return self._current?.container
        }
        public var animationVelocity: Double
#if os(iOS)
        public var interactiveLimit: Double
#endif
        
        private var _layout: Layout
        private var _view: CustomView
#if os(iOS)
        private var _interactiveGesture = PanGesture()
            .enabled(false)
        private var _interactiveBeginLocation: Point?
#endif
        private var _items: [Container.PushItem]
        private var _previous: Container.PushItem?
        private var _current: Container.PushItem? {
            didSet {
#if os(iOS)
                self._interactiveGesture.isEnabled = self._current != nil
#endif
            }
        }
        private var _timer: KindTimer.Once?
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            inset: Inset = Inset(horizontal: 8, vertical: 8),
            content: (IContainer & IContainerParentable)? = nil
        ) {
            self.isPresented = false
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity * 0.5
#elseif os(iOS)
            self.animationVelocity = UIScreen.kk_animationVelocity * 0.5
            self.interactiveLimit = 20
#endif
            self.content = content
            self._layout = .init(
                inset: inset,
                content: content?.view
            )
            self._view = CustomView()
                .content(self._layout)
#if os(iOS)
                .gestures([ self._interactiveGesture ])
#endif
            self._items = []
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
            self._layout.contentInset = contentInset.interactive
            for item in self._items {
                item.update(
                    self._view.bounds.size,
                    self.inset + self._layout.parentInset,
                    self.inset + self._layout.contentInset
                )
            }
            for container in self.containers {
                container.apply(contentInset: contentInset)
            }
            if let content = self.content {
                content.apply(contentInset: contentInset)
            }
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> Container.AccumulateInset {
            guard let content = self.content else { return .zero }
            return content.contentInset()
        }
        
        public func refreshParentInset() {
            let parentInset = self.parentInset()
            self._layout.parentInset = parentInset.interactive
            for item in self._items {
                item.update(
                    self._view.bounds.size,
                    self.inset + self._layout.parentInset,
                    self.inset + self._layout.contentInset
                )
            }
            self.content?.refreshParentInset()
            for container in self.containers {
                container.refreshParentInset()
            }
        }
        
        public func activate() -> Bool {
            if let current = self._current {
                if current.container.activate() == true {
                    return true
                }
            }
            if let content = self.content {
                return content.activate()
            }
            return false
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            if let current = self._current {
                if current.container.snake() == true {
                    return true
                }
            }
            if let content = self.content {
                return content.snake()
            }
            return false
        }
        
#endif
        
        public func didChangeAppearance() {
            for container in self.containers {
                container.didChangeAppearance()
            }
            if let content = self.content {
                content.didChangeAppearance()
            }
        }
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
        public func prepareShow(interactive: Bool) {
            self.content?.prepareShow(interactive: interactive)
            self.current?.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.content?.finishShow(interactive: interactive)
            self.current?.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.content?.cancelShow(interactive: interactive)
            self.current?.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.content?.prepareHide(interactive: interactive)
            self.current?.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.content?.finishHide(interactive: interactive)
            self.current?.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.content?.cancelHide(interactive: interactive)
            self.current?.cancelHide(interactive: interactive)
        }
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            if let container = container as? IPushContentContainer {
                if self.dismiss(container: container, animated: animated, completion: completion) == false {
                    return self.close(animated: animated, completion: completion)
                }
            } else if let parent = self.parent {
                return parent.close(container: self, animated: animated, completion: completion)
            }
            return false
        }
        
        public func present(container: IPushContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard self._items.contains(where: { $0.container === container }) == false else {
                completion?()
                return
            }
            container.parent = self
            let item = Container.PushItem(
                container,
                self._view.bounds.size,
                self.inset + self._layout.parentInset,
                self.inset + self._layout.contentInset
            )
            self._items.append(item)
            if self._current == nil && self._animation == nil {
                self._present(push: item, animated: animated, completion: completion)
            } else {
                completion?()
            }
        }
        
        @discardableResult
        public func dismiss(container: IPushContentContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let index = self._items.firstIndex(where: { $0.container === container }) else {
                completion?()
                return false
            }
            let item = self._items[index]
            if self._current === item {
                self._items.remove(at: index)
                self._previous = self._items.first
                self._dismiss(current: item, previous: self._previous, animated: animated, completion: {
                    container.parent = nil
                    completion?()
                })
            } else {
                container.parent = nil
                self._items.remove(at: index)
                completion?()
            }
            return true
        }
        
    }
    
}

extension Container.Push : IRootContentContainer {
}

private extension Container.Push {
    
    func _setup() {
        self._view.onHit(self, {
            guard let current = $0._current else { return false }
            guard current.container.shouldInteractive == true else { return false }
            return current.container.view.isContains($1, from: $0._view)
        })
#if os(iOS)
        self._interactiveGesture
            .onShouldBegin(self, {
                guard let current = $0._current else { return false }
                guard current.container.shouldInteractive == true else { return false }
                guard $0._interactiveGesture.contains(in: current.container.view) == true else { return false }
                return true
            })
            .onShouldBeRequiredToFailBy(self, {
                guard let content = $0.content else { return true }
                guard let view = $1.view else { return false }
                return content.view.native.kk_isChild(of: view, recursive: true)
            })
            .onBegin(self, { $0._beginInteractiveGesture() })
            .onChange(self, { $0._changeInteractiveGesture() })
            .onCancel(self, { $0._endInteractiveGesture(true) })
            .onEnd(self, { $0._endInteractiveGesture(false) })
#endif
        self.content?.parent = self
    }
    
    func _destroy() {
        self._animation = nil
        self._timer = nil
    }
    
    func _timerTriggered() {
        self._timer = nil
        if let currentItem = self._current {
            if let index = self._items.firstIndex(where: { $0 === currentItem }) {
                self._items.remove(at: index)
            }
            self._previous = self._items.first
            self._dismiss(current: currentItem, previous: self._previous, animated: true, completion: {
                currentItem.container.parent = nil
            })
        }
    }
    
    func _present(current: Container.PushItem?, next: Container.PushItem, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(push: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(push: next, animated: animated, completion: completion)
            })
        } else {
            self._present(push: next, animated: animated, completion: completion)
        }
    }
    
    func _present(push: Container.PushItem, animated: Bool, completion: (() -> Void)?) {
        self._current = push
        if animated == true {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: self._layout.duration(item: push, velocity: self.animationVelocity),
                    ease: KindAnimation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._view.locked = true
                        self._layout.state = .present(push: push, progress: .zero)
                        if self.isPresented == true {
                            push.container.refreshParentInset()
                            push.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .present(push: push, progress: progress)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._view.locked = false
                        self._layout.state = .idle(push: push)
                        self._didPresent(push: push)
                        if self.isPresented == true {
                            push.container.finishShow(interactive: false)
                        }
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        completion?()
                    }
                )
            )
        } else {
            self._layout.state = .idle(push: push)
            self._didPresent(push: push)
            if self.isPresented == true {
                push.container.refreshParentInset()
                push.container.prepareShow(interactive: false)
                push.container.finishShow(interactive: false)
            }
#if os(iOS)
            self.refreshOrientations()
            self.refreshStatusBar()
#endif
        }
    }
    
    func _didPresent(push: Container.PushItem) {
        if let duration = push.container.pushDuration {
            self._timer = .init(interval: .timeInterval(duration))
                .onTriggered(self, { $0._timerTriggered() })
                .start()
        } else {
            self._timer = nil
        }
    }
    
    func _dismiss(current: Container.PushItem, previous: Container.PushItem?, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(push: current, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            self._current = previous
            if let previous = previous {
                self._present(push: previous, animated: animated, completion: completion)
            } else if self._current == nil && self._items.isEmpty == false {
                self._present(push: self._items[0], animated: animated, completion: completion)
            } else {
                completion?()
            }
        })
    }
    
    func _dismiss(push: Container.PushItem, animated: Bool, completion: (() -> Void)?) {
        push.container.prepareHide(interactive: false)
        if animated == true {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: self._layout.duration(item: push, velocity: self.animationVelocity),
                    ease: KindAnimation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._view.locked = true
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .dismiss(push: push, progress: progress)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._view.locked = false
                        self._layout.state = .empty
                        push.container.finishHide(interactive: false)
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        completion?()
                    }
                )
            )
        } else {
            push.container.finishHide(interactive: false)
            self._layout.state = .empty
#if os(iOS)
            self.refreshOrientations()
            self.refreshStatusBar()
#endif
        }
    }
    
}

#if os(iOS)

private extension Container.Push {
    
    func _beginInteractiveGesture() {
        guard let current = self._current else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        self._timer?.pause()
        current.container.prepareHide(interactive: true)
    }
    
    func _changeInteractiveGesture() {
        guard let current = self._current else { return }
        guard let beginLocation = self._interactiveBeginLocation else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = self._layout.delta(item: current, begin: beginLocation, current: currentLocation)
        self._layout.state = self._layout.state(item: current, delta: deltaLocation)
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let current = self._current else { return }
        guard let beginLocation = self._interactiveBeginLocation else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = self._layout.delta(item: current, begin: beginLocation, current: currentLocation)
        switch self._layout.state(item: current, delta: deltaLocation) {
        case .empty:
            self._layout.state = .idle(push: current)
            self._cancelInteractiveAnimation()
        case .idle:
            self._layout.state = .idle(push: current)
            self._cancelInteractiveAnimation()
        case .present(_, let baseProgress):
            let overProgress = baseProgress - .one
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: self._layout.cancelDuration(item: current, progress: overProgress, velocity: self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .present(push: current, progress: .one + (overProgress * progress.invert))
                        self._layout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._cancelInteractiveAnimation()
                    }
                )
            )
        case .dismiss(_, let baseProgress):
            if deltaLocation > self.interactiveLimit {
                let duration = self._layout.duration(item: current, velocity: self.animationVelocity)
                let elapsed = duration * TimeInterval(baseProgress.value)
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: duration,
                        elapsed: elapsed,
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .dismiss(push: current, progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._finishInteractiveAnimation()
                        }
                    )
                )
            } else {
                let overProgress = baseProgress - .one
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: self._layout.cancelDuration(item: current, progress: overProgress, velocity: self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .present(push: current, progress: .one + (overProgress * progress.invert))
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._cancelInteractiveAnimation()
                        }
                    )
                )
            }
        }
    }
    
    func _finishInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._timer = nil
        self._animation = nil
        if let current = self._current {
            current.container.finishHide(interactive: true)
            current.container.parent = nil
            if let index = self._items.firstIndex(where: { $0 === current }) {
                self._items.remove(at: index)
            }
            self._previous = self._items.first
            if let previous = self._previous {
                self._present(push: previous, animated: true, completion: nil)
            } else {
                self._current = nil
                self._layout.state = .empty
                self.refreshOrientations()
                self.refreshStatusBar()
            }
        } else {
            self._current = nil
            self._layout.state = .empty
            self.refreshOrientations()
            self.refreshStatusBar()
        }
    }
    
    func _cancelInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._animation = nil
        self._timer?.start()
        if let current = self._current {
            current.container.cancelHide(interactive: true)
            self._layout.state = .idle(push: current)
        } else {
            self._layout.state = .empty
        }
        self.refreshOrientations()
        self.refreshStatusBar()
    }
    
}

#endif
