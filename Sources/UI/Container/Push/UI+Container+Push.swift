//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension UI.Container {
    
    final class Push : IUIPushContainer {
        
        public weak var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.refreshParentInset()
                    }
                } else {
                    self.refreshParentInset()
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
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
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
        public var content: (IUIContainer & IUIContainerParentable)? {
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
        public var containers: [IUIPushContentContainer] {
            return self._items.map({ return $0.container })
        }
        public var previous: IUIPushContentContainer? {
            return self._previous?.container
        }
        public var current: IUIPushContentContainer? {
            return self._current?.container
        }
        public var animationVelocity: Double
#if os(iOS)
        public var interactiveLimit: Double
#endif
        
        private var _layout: Layout
        private var _view: UI.View.Custom
#if os(iOS)
        private var _interactiveGesture = UI.Gesture.Pan()
            .enabled(false)
        private var _interactiveBeginLocation: Point?
#endif
        private var _items: [UI.Container.PushItem]
        private var _previous: UI.Container.PushItem?
        private var _current: UI.Container.PushItem? {
            didSet {
#if os(iOS)
                self._interactiveGesture.isEnabled = self._current != nil
#endif
            }
        }
        private var _timer: Timer?
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            inset: Inset = Inset(horizontal: 8, vertical: 8),
            content: (IUIContainer & IUIContainerParentable)? = nil
        ) {
            self.isPresented = false
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity / 2.5
#elseif os(iOS)
            self.animationVelocity = UIScreen.kk_animationVelocity / 2.5
            self.interactiveLimit = 20
#endif
            self.content = content
            self._layout = .init(
                inset: inset,
                content: content?.view
            )
            self._view = UI.View.Custom()
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
        
        public func apply(contentInset: UI.Container.AccumulateInset) {
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
        
        public func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> UI.Container.AccumulateInset {
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
        
        public func didChangeAppearance() {
            for container in self.containers {
                container.didChangeAppearance()
            }
            if let content = self.content {
                content.didChangeAppearance()
            }
        }
        
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
        
        public func present(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard self._items.contains(where: { $0.container === container }) == false else {
                completion?()
                return
            }
            container.parent = self
            let item = UI.Container.PushItem(
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
        
        public func dismiss(container: IUIPushContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard let index = self._items.firstIndex(where: { $0.container === container }) else {
                completion?()
                return
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
        }
        
    }
    
}

extension UI.Container.Push : IUIRootContentContainer {
}

private extension UI.Container.Push {
    
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
    
    func _present(current: UI.Container.PushItem?, next: UI.Container.PushItem, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(push: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(push: next, animated: animated, completion: completion)
            })
        } else {
            self._present(push: next, animated: animated, completion: completion)
        }
    }
    
    func _present(push: UI.Container.PushItem, animated: Bool, completion: (() -> Void)?) {
        self._current = push
        if animated == true {
            self._animation = Animation.default.run(
                .custom(
                    duration: self._layout.duration(item: push, velocity: self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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
    
    func _didPresent(push: UI.Container.PushItem) {
        if let duration = push.container.pushDuration {
            self._timer = Timer(interval: duration, delay: 0, repeating: 0)
                .onFinished(self, { $0._timerTriggered() })
                .start()
        } else {
            self._timer = nil
        }
    }
    
    func _dismiss(current: UI.Container.PushItem, previous: UI.Container.PushItem?, animated: Bool, completion: (() -> Void)?) {
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
    
    func _dismiss(push: UI.Container.PushItem, animated: Bool, completion: (() -> Void)?) {
        push.container.prepareHide(interactive: false)
        if animated == true {
            self._animation = Animation.default.run(
                .custom(
                    duration: self._layout.duration(item: push, velocity: self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
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

private extension UI.Container.Push {
    
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
        let progress = self._layout.progress(item: current, delta: deltaLocation)
        if progress >= .one {
            self._layout.state = .present(push: current, progress: progress)
        } else {
            self._layout.state = .dismiss(push: current, progress: progress)
        }
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let current = self._current else { return }
        guard let beginLocation = self._interactiveBeginLocation else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = self._layout.delta(item: current, begin: beginLocation, current: currentLocation)
        let baseProgress = self._layout.progress(item: current, delta: deltaLocation)
        if deltaLocation > self.interactiveLimit {
            let duration = self._layout.duration(item: current, velocity: self.animationVelocity)
            let elapsed = duration * TimeInterval(baseProgress.value)
            self._animation = Animation.default.run(
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
        } else if baseProgress >= .one {
            let overProgress = baseProgress - .one
            self._animation = Animation.default.run(
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
        } else {
            self._layout.state = .idle(push: current)
            self._cancelInteractiveAnimation()
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
        self._timer?.resume()
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
