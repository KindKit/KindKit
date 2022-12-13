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
    
    final class Modal : IUIModalContainer {
        
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
        public var containers: [IUIModalContentContainer] {
            return self._items.map({ return $0.container })
        }
        public var previous: IUIModalContentContainer? {
            return self._previous?.container
        }
        public var current: IUIModalContentContainer? {
            return self._current?.container
        }
        public var animationVelocity: Double
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        private var _tapGesture = UI.Gesture.Tap().enabled(false)
#if os(iOS)
        private var _interactiveGesture = UI.Gesture.Pan().enabled(false)
        private var _interactiveBeginLocation: Point?
#endif
        private var _items: [UI.Container.ModalItem]
        private var _previous: UI.Container.ModalItem?
        private var _current: UI.Container.ModalItem? {
            didSet {
                self._tapGesture.isEnabled = self._current != nil
#if os(iOS)
                self._interactiveGesture.isEnabled = self._current != nil
#endif
            }
        }
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            content: (IUIContainer & IUIContainerParentable)? = nil
        ) {
            self.isPresented = false
            self.content = content
            self._layout = Layout(content?.view)
            self._view = UI.View.Custom()
                .content(self._layout)
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity
#elseif os(iOS)
            self.animationVelocity = Double(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 3)
#endif
            self._items = []
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: UI.Container.AccumulateInset) {
            for container in self.containers {
                container.apply(contentInset: contentInset)
            }
            if let content = self.content {
                content.apply(contentInset: contentInset)
            }
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
            let parentInset = self.parentInset()
            if let current = self._current?.container {
                if current.modalSheet != nil {
                    return .init(
                        natural: .init(
                            top: 0,
                            left: parentInset.natural.left,
                            right: parentInset.natural.right,
                            bottom: parentInset.natural.bottom
                        ),
                        interactive: .init(
                            top: 0,
                            left: parentInset.interactive.left,
                            right: parentInset.interactive.right,
                            bottom: parentInset.interactive.bottom
                        )
                    )
                }
            }
            return parentInset
        }
        
        public func contentInset() -> UI.Container.AccumulateInset {
            guard let content = self.content else { return .zero }
            let contentInset = content.contentInset()
            switch self._layout.state {
            case .empty:
                return contentInset
            case .idle(let modal, _):
                return modal.container.contentInset()
            case .transition(let modal, let from, let to, let progress):
                if from == modal.sheet?.minimalDetent {
                    let modalInset = modal.container.contentInset()
                    return contentInset.lerp(modalInset, progress: progress)
                } else if to == modal.sheet?.minimalDetent {
                    let modalInset = modal.container.contentInset()
                    return modalInset.lerp(contentInset, progress: progress)
                }
                return modal.container.contentInset()
            }
        }
        
        public func refreshParentInset() {
            let parentInset = self.parentInset()
            self._layout.inset = parentInset.natural
            self.content?.refreshParentInset()
            for container in self.containers {
                container.refreshParentInset()
            }
        }
        
        public func activate() -> Bool {
            if let current = self._current?.container {
                if current.activate() == true {
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
        
        public func present(container: IUIModalContentContainer, animated: Bool, completion: (() -> Void)?) {
            container.parent = self
            let item = UI.Container.ModalItem(container)
            self._items.append(item)
            if self._current == nil && self._animation == nil {
                self._present(modal: item, animated: animated, completion: completion)
            } else {
                completion?()
            }
        }
        
        public func present< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIModalContentContainer {
            wireframe.container.parent = self
            let item = UI.Container.ModalItem(wireframe.container, wireframe)
            self._items.append(item)
            if self._current == nil && self._animation == nil {
                self._present(modal: item, animated: animated, completion: completion)
            } else {
                completion?()
            }
        }
        
        public func dismiss(container: IUIModalContentContainer, animated: Bool, completion: (() -> Void)?) {
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
        
        public func dismiss< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIModalContentContainer {
            self.dismiss(container: wireframe.container, animated: animated, completion: completion)
        }
        
    }
    
}

extension UI.Container.Modal : IUIRootContentContainer {
}

private extension UI.Container.Modal {
    
    func _setup() {
        self._view.onHit(self, {
            guard let current = $0._current else { return false }
            guard current.container.shouldInteractive == true else { return false }
            return current.container.view.isContains($1, from: $0._view)
        })
        self._view.add(gesture: self._tapGesture)
#if os(iOS)
        self._view.add(gesture: self._interactiveGesture)
        self._interactiveGesture
            .onShouldBegin(self, {
                guard let current = $0._current else { return false }
                guard current.container.shouldInteractive == true else { return false }
                return $0._interactiveGesture.contains(in: current.container.view)
            })
            .onShouldRequireFailure(self, {
                guard let view = $1.view else { return false }
                guard let current = $0._current else { return false }
                return current.container.view.native.kk_isChild(of: view, recursive: true)
            })
            .onShouldBeRequiredToFailBy(self, {
                guard let view = $1.view else { return false }
                guard let current = $0._current else { return false }
                return current.container.view.native.kk_isChild(of: view, recursive: true)
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
    }
    
    func _present(current: UI.Container.ModalItem?, next: UI.Container.ModalItem, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(modal: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(modal: next, animated: animated, completion: completion)
            })
        } else {
            self._present(modal: next, animated: animated, completion: completion)
        }
    }
    
    func _present(modal: UI.Container.ModalItem, animated: Bool, completion: (() -> Void)?) {
        self._current = modal
        if self.isPresented == true && animated == true {
            self._animation = Animation.default.run(
                .custom(
                    duration: TimeInterval(self._view.bounds.size.height / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._view.locked = true
                        self._layout.state = .present(modal: modal, progress: .zero)
                        modal.container.refreshParentInset()
                        modal.container.prepareShow(interactive: false)
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .present(modal: modal, progress: progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._view.locked = false
                        self._layout.state = .idle(modal: modal)
                        modal.container.finishShow(interactive: false)
                        self.refreshContentInset()
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        completion?()
                    }
                )
            )
        } else {
            self._layout.state = .idle(modal: modal)
            self.refreshContentInset()
            if self.isPresented == true {
                modal.container.refreshParentInset()
                modal.container.prepareShow(interactive: false)
                modal.container.finishShow(interactive: false)
#if os(iOS)
                self.refreshOrientations()
                self.refreshStatusBar()
#endif
            }
            completion?()
        }
    }
    
    func _dismiss(current: UI.Container.ModalItem, previous: UI.Container.ModalItem?, animated: Bool, completion: (() -> Void)?) {
        self._current = previous
        self._dismiss(modal: current, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            if let previous = previous {
                self._present(modal: previous, animated: animated, completion: completion)
            } else if self._current == nil && self._items.isEmpty == false {
                self._present(modal: self._items[0], animated: animated, completion: completion)
            } else {
                completion?()
            }
        })
    }
    
    func _dismiss(modal: UI.Container.ModalItem, animated: Bool, completion: (() -> Void)?) {
        if self.isPresented == true {
            modal.container.prepareHide(interactive: false)
        }
        if self.isPresented == true && animated == true {
            self._animation = Animation.default.run(
                .custom(
                    duration: TimeInterval(self._view.bounds.size.height / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._view.locked = true
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .dismiss(modal: modal, progress: progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._view.locked = false
                        self._layout.state = .empty
                        modal.container.finishHide(interactive: false)
                        self.refreshContentInset()
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        completion?()
                    }
                )
            )
        } else {
            self._layout.state = .empty
            if self.isPresented == true {
                modal.container.finishHide(interactive: false)
#if os(iOS)
                self.refreshOrientations()
                self.refreshStatusBar()
#endif
            }
            self.refreshContentInset()
            completion?()
        }
    }
    
}

#if os(iOS)

private extension UI.Container.Modal {
    
    func _beginInteractiveGesture() {
        guard let current = self._current else { return }
        let location = self._interactiveGesture.location(in: self._view)
        self._interactiveBeginLocation = location
        current.container.prepareHide(interactive: true)
        self._layout.beginInteractive(
            modal: current
        )
    }
    
    func _changeInteractiveGesture() {
        guard let current = self._current else { return }
        guard let beginLocation = self._interactiveBeginLocation else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        self._layout.changeInteractive(
            modal: current,
            delta: currentLocation.y - beginLocation.y
        )
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let current = self._current else { return }
        guard let beginLocation = self._interactiveBeginLocation else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        self._animation = self._layout.endInteractive(
            modal: current,
            velocity: self.animationVelocity,
            delta: currentLocation.y - beginLocation.y,
            animation: { [weak self] _ in
                guard let self = self else { return }
                self.refreshContentInset()
            },
            finish: { [weak self] in
                guard let self = self else { return }
                self._finishInteractiveAnimation()
            },
            cancel: { [weak self] in
                guard let self = self else { return }
                self._cancelInteractiveAnimation()
            }
        )
    }
    
    func _finishInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._animation = nil
        if let current = self._current {
            current.container.finishHide(interactive: true)
            current.container.parent = nil
            if let index = self._items.firstIndex(where: { $0 === current }) {
                self._items.remove(at: index)
            }
            self._previous = self._items.first
            if let previous = self._previous {
                self._present(modal: previous, animated: true, completion: nil)
            } else {
                self._current = nil
            }
        } else {
            self._current = nil
            if self.isPresented == true {
#if os(iOS)
                self.refreshOrientations()
                self.refreshStatusBar()
#endif
            }
        }
        self.refreshContentInset()
    }
    
    func _cancelInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._animation = nil
        if let current = self._current {
            current.container.cancelHide(interactive: true)
        }
        self.refreshContentInset()
    }
    
}

#endif
