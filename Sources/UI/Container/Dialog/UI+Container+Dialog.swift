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
    
    final class Dialog : IUIDialogContainer {
        
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
        public var containers: [IUIDialogContentContainer] {
            return self._items.map({ return $0.container })
        }
        public var previous: IUIDialogContentContainer? {
            return self._previous?.container
        }
        public var current: IUIDialogContentContainer? {
            return self._current?.container
        }
        public var animationVelocity: Double
#if os(iOS)
        public var interactiveLimit: Double
#endif
        
        private var _layout: Layout
        private var _view: UI.View.Custom
#if os(iOS)
        private var _interactiveGesture = UI.Gesture.Pan().enabled(false)
        private var _interactiveBeginLocation: Point?
        private var _interactiveDialogItem: UI.Container.DialogItem?
        private var _interactiveDialogSize: Size?
#endif
        private var _items: [UI.Container.DialogItem]
        private var _previous: UI.Container.DialogItem?
        private var _current: UI.Container.DialogItem? {
            didSet {
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
#if os(macOS)
            self.animationVelocity = 1200
#elseif os(iOS)
            self.animationVelocity = 1200
            self.interactiveLimit = 20
#endif
            self._layout = Layout(
                inset: .zero,
                content: content?.view,
                state: .idle
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
            self._layout.inset = parentInset.interactive
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
        
        public func present(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?) {
            container.parent = self
            let item = UI.Container.DialogItem(container, self._view.bounds.size)
            self._items.append(item)
            if self._current == nil && self._animation == nil {
                self._present(dialog: item, animated: animated, completion: completion)
            } else {
                completion?()
            }
        }
        
        public func dismiss(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?) {
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

extension UI.Container.Dialog : IUIRootContentContainer {
}

extension UI.Container.Dialog {
    
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
    }
    
    func _present(current: UI.Container.DialogItem?, next: UI.Container.DialogItem, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(dialog: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(dialog: next, animated: animated, completion: completion)
            })
        } else {
            self._present(dialog: next, animated: animated, completion: completion)
        }
    }
    
    func _present(dialog: UI.Container.DialogItem, animated: Bool, completion: (() -> Void)?) {
        self._current = dialog
        self._layout.dialogItem = dialog
        self._layout.state = .present(progress: .zero)
        if self.isPresented == true {
            dialog.container.refreshParentInset()
        }
        if let dialogSize = self._layout.dialogSize {
            dialog.container.prepareShow(interactive: false)
            if self.isPresented == true && animated == true {
                let size = self._layout._size(dialog: dialog, size: dialogSize)
                self._animation = Animation.default.run(
                    .custom(
                        duration: TimeInterval(size / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
                        preparing: { [weak self] in
                            guard let self = self else { return }
                            self._view.locked = true
                        },
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .present(progress: progress)
                            self._layout.updateIfNeeded()
                            self.refreshContentInset()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._view.locked = false
                            self._layout.state = .idle
                            dialog.container.finishShow(interactive: false)
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
                dialog.container.finishShow(interactive: false)
                self._layout.state = .idle
                self.refreshContentInset()
#if os(iOS)
                self.refreshOrientations()
                self.refreshStatusBar()
#endif
                completion?()
            }
        } else {
            self._layout.state = .idle
            self._layout.dialogItem = nil
            self.refreshContentInset()
#if os(iOS)
            self.refreshOrientations()
            self.refreshStatusBar()
#endif
            completion?()
        }
    }
    
    func _dismiss(current: UI.Container.DialogItem, previous: UI.Container.DialogItem?, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(dialog: current, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            self._current = previous
            if let previous = previous {
                self._present(dialog: previous, animated: animated, completion: completion)
            } else  if self._current == nil && self._items.isEmpty == false {
                self._present(dialog: self._items[0], animated: animated, completion: completion)
            } else {
                completion?()
            }
        })
    }
    
    func _dismiss(dialog: UI.Container.DialogItem, animated: Bool, completion: (() -> Void)?) {
        self._layout.dialogItem = dialog
        self._layout.state = .dismiss(progress: .zero)
        if self.isPresented == true {
            dialog.container.refreshParentInset()
        }
        if let dialogSize = self._layout.dialogSize {
            dialog.container.prepareHide(interactive: false)
            if self.isPresented == true && animated == true {
                let size = self._layout._size(dialog: dialog, size: dialogSize)
                self._animation = Animation.default.run(
                    .custom(
                        duration: TimeInterval(size / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
                        preparing: { [weak self] in
                            guard let self = self else { return }
                            self._view.locked = true
                        },
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .dismiss(progress: progress)
                            self._layout.updateIfNeeded()
                            self.refreshContentInset()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._view.locked = false
                            self._layout.state = .idle
                            self._layout.dialogItem = nil
                            dialog.container.finishHide(interactive: false)
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
                dialog.container.finishHide(interactive: false)
                self._layout.state = .idle
                self._layout.dialogItem = nil
                self.refreshContentInset()
#if os(iOS)
                self.refreshOrientations()
                self.refreshStatusBar()
#endif
                completion?()
            }
        } else {
            self._layout.state = .idle
            self._layout.dialogItem = nil
            self.refreshContentInset()
#if os(iOS)
            self.refreshOrientations()
            self.refreshStatusBar()
#endif
            completion?()
        }
    }
    
}

#if os(iOS)

private extension UI.Container.Dialog {
    
    func _beginInteractiveGesture() {
        guard let current = self._current else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        self._interactiveDialogItem = self._layout.dialogItem
        self._interactiveDialogSize = self._layout.dialogSize
        current.container.prepareHide(interactive: true)
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation else { return }
        guard let dialogItem = self._interactiveDialogItem else { return }
        guard let dialogSize = self._interactiveDialogSize else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation - beginLocation
        let progress = self._layout._progress(dialog: dialogItem, size: dialogSize, delta: deltaLocation)
        self._layout.state = .dismiss(progress: progress)
        self.refreshContentInset()
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation else { return }
        guard let dialogItem = self._interactiveDialogItem else { return }
        guard let dialogSize = self._interactiveDialogSize else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation - beginLocation
        let size = self._layout._size(dialog: dialogItem, size: dialogSize)
        let offset = self._layout._offset(dialog: dialogItem, size: dialogSize, delta: deltaLocation)
        let baseProgress = self._layout._progress(dialog: dialogItem, size: dialogSize, delta: deltaLocation)
        if offset > self.interactiveLimit {
            let viewAlphable = self._layout.dialogItem?.container.view as? IUIViewAlphable
            self._animation = Animation.default.run(
                .custom(
                    duration: TimeInterval(size / self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        if let view = viewAlphable {
                            view.alpha(progress.invert.value)
                        }
                        self._layout.state = .dismiss(progress: baseProgress + progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        if let view = viewAlphable {
                            view.alpha(1)
                        }
                        self._finishInteractiveAnimation()
                    }
                )
            )
        } else {
            self._animation = Animation.default.run(
                .custom(
                    duration: TimeInterval((size * abs(baseProgress.value)) / self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .dismiss(progress: baseProgress * progress.invert)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._cancelInteractiveAnimation()
                    }
                )
            )
        }
    }
    
    func _finishInteractiveAnimation() {
        self._resetInteractiveAnimation()
        if let current = self._current {
            current.container.finishHide(interactive: true)
            current.container.parent = nil
            if let index = self._items.firstIndex(where: { $0 === current }) {
                self._items.remove(at: index)
            }
            self._previous = self._items.first
            if let previous = self._previous {
                self._present(dialog: previous, animated: true, completion: nil)
            } else {
                self._current = nil
                self._layout.state = .idle
                self._layout.dialogItem = nil
                self.refreshContentInset()
                self.refreshOrientations()
                self.refreshStatusBar()
            }
        } else {
            self._current = nil
            self._layout.state = .idle
            self._layout.dialogItem = nil
            self.refreshContentInset()
            self.refreshOrientations()
            self.refreshStatusBar()
        }
    }
    
    func _cancelInteractiveAnimation() {
        self._resetInteractiveAnimation()
        if let current = self._current {
            current.container.cancelHide(interactive: true)
        }
        self._layout.state = .idle
        self.refreshContentInset()
        self.refreshOrientations()
        self.refreshStatusBar()
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._interactiveDialogItem = nil
        self._interactiveDialogSize = nil
        self._animation = nil
    }
    
}

#endif
