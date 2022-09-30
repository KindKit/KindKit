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
        
        public unowned var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
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
            didSet {
                if let content = self.content {
                    if self.isPresented == true {
                        content.prepareHide(interactive: false)
                        content.finishHide(interactive: false)
                    }
                    content.parent = nil
                }
                self._layout.content = self.content.flatMap({ UI.Layout.Item($0.view) })
                if let content = self.content {
                    content.parent = self
                    if self.isPresented == true {
                        content.prepareHide(interactive: false)
                        content.finishHide(interactive: false)
                    }
                }
            }
        }
        public var containers: [IUIDialogContentContainer] {
            return self._items.compactMap({ return $0.container })
        }
        public var previous: IUIDialogContentContainer? {
            return self._previous?.container
        }
        public var current: IUIDialogContentContainer? {
            return self._current?.container
        }
        public var animationVelocity: Float
#if os(iOS)
        public var interactiveLimit: Float
#endif
        
        private var _layout: Layout
        private var _view: UI.View.Custom
#if os(iOS)
        private var _interactiveGesture = UI.Gesture.Pan().enabled(false)
        private var _interactiveBeginLocation: PointFloat?
        private var _interactiveDialogItem: Item?
        private var _interactiveDialogSize: SizeFloat?
#endif
        private var _items: [Item]
        private var _previous: Item?
        private var _current: Item? {
            didSet {
#if os(iOS)
                self._interactiveGesture.isEnabled = self._current != nil
#endif
            }
        }
        private var _animation: IAnimationTask? {
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
                content: content.flatMap({ UI.Layout.Item($0.view) }),
                state: .idle
            )
            self._view = UI.View.Custom(self._layout)
#if os(iOS)
            self._view.gestures([ self._interactiveGesture ])
#endif
            self._items = []
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
            self._layout.inset = self.inheritedInsets(interactive: true)
            self.content?.didChangeInsets()
            for container in self.containers {
                container.didChangeInsets()
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
        
        public func present(container: IUIDialogContentContainer, animated: Bool, completion: (() -> Void)?) {
            container.parent = self
            let item = Item(container: container, available: self._view.bounds.size)
            self._items.append(item)
            if self._current == nil {
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
#if os(iOS)
        self._interactiveGesture.onShouldBeRequiredToFailBy({ [unowned self] _, gesture -> Bool in
            guard let content = self.content else { return true }
            guard let view = gesture.view else { return false }
            return content.view.native.isChild(of: view, recursive: true)
        }).onShouldBegin({ [unowned self] _ in
            guard let current = self._current else { return false }
            guard current.container.shouldInteractive == true else { return false }
            guard self._interactiveGesture.contains(in: current.container.view) == true else { return false }
            return true
        }).onBegin({ [unowned self] _ in
            self._beginInteractiveGesture()
        }) .onChange({ [unowned self] _ in
            self._changeInteractiveGesture()
        }).onCancel({ [unowned self] _ in
            self._endInteractiveGesture(true)
        }).onEnd({ [unowned self] _ in
            self._endInteractiveGesture(false)
        })
#endif
        self.content?.parent = self
    }
    
    func _destroy() {
        self._animation = nil
    }
    
    func _present(current: Item?, next: Item, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(dialog: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(dialog: next, animated: animated, completion: completion)
            })
        } else {
            self._present(dialog: next, animated: animated, completion: completion)
        }
    }
    
    func _present(dialog: Item, animated: Bool, completion: (() -> Void)?) {
        self._current = dialog
        self._layout.dialogItem = dialog
        self._layout.state = .present(progress: .zero)
        if self.isPresented == true {
            dialog.container.didChangeInsets()
        }
        if let dialogSize = self._layout.dialogSize {
            dialog.container.prepareShow(interactive: false)
            if animated == true {
                let size = self._layout._size(dialog: dialog, size: dialogSize)
                self._animation = Animation.default.run(
                    duration: TimeInterval(size / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self._layout.state = .present(progress: progress)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [unowned self] in
                        self._animation = nil
                        self._layout.state = .idle
                        dialog.container.finishShow(interactive: false)
#if os(iOS)
                        self.setNeedUpdateOrientations()
                        self.setNeedUpdateStatusBar()
#endif
                        completion?()
                    }
                )
            } else {
                dialog.container.finishShow(interactive: false)
                self._layout.state = .idle
#if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
#endif
                completion?()
            }
        } else {
            self._layout.state = .idle
            self._layout.dialogItem = nil
#if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
#endif
            completion?()
        }
    }
    
    func _dismiss(current: Item, previous: Item?, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(dialog: current, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            self._current = previous
            if let previous = previous {
                self._present(dialog: previous, animated: animated, completion: completion)
            } else {
                completion?()
            }
        })
    }
    
    func _dismiss(dialog: Item, animated: Bool, completion: (() -> Void)?) {
        self._layout.dialogItem = dialog
        self._layout.state = .dismiss(progress: .zero)
        if self.isPresented == true {
            dialog.container.didChangeInsets()
        }
        if let dialogSize = self._layout.dialogSize {
            dialog.container.prepareHide(interactive: false)
            if animated == true {
                let size = self._layout._size(dialog: dialog, size: dialogSize)
                self._animation = Animation.default.run(
                    duration: TimeInterval(size / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self._layout.state = .dismiss(progress: progress)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [unowned self] in
                        self._animation = nil
                        self._layout.state = .idle
                        self._layout.dialogItem = nil
                        dialog.container.finishHide(interactive: false)
#if os(iOS)
                        self.setNeedUpdateOrientations()
                        self.setNeedUpdateStatusBar()
#endif
                        completion?()
                    }
                )
            } else {
                dialog.container.finishHide(interactive: false)
                self._layout.state = .idle
                self._layout.dialogItem = nil
#if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
#endif
                completion?()
            }
        } else {
            self._layout.state = .idle
            self._layout.dialogItem = nil
#if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
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
                duration: TimeInterval(size / self.animationVelocity),
                processing: { [unowned self] progress in
                    if let view = viewAlphable {
                        view.alpha(progress.invert.value)
                    }
                    self._layout.state = .dismiss(progress: baseProgress + progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    if let view = viewAlphable {
                        view.alpha(1)
                    }
                    self._finishInteractiveAnimation()
                }
            )
        } else {
            self._animation = Animation.default.run(
                duration: TimeInterval((size * abs(baseProgress.value)) / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._layout.state = .dismiss(progress: baseProgress * progress.invert)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._cancelInteractiveAnimation()
                }
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
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
            }
        } else {
            self._current = nil
            self._layout.state = .idle
            self._layout.dialogItem = nil
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
        }
    }
    
    func _cancelInteractiveAnimation() {
        self._resetInteractiveAnimation()
        if let current = self._current {
            current.container.cancelHide(interactive: true)
        }
        self._layout.state = .idle
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._interactiveDialogItem = nil
        self._interactiveDialogSize = nil
        self._animation = nil
    }
    
}

#endif
