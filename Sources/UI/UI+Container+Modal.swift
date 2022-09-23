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
        
        public unowned var parent: IUIContainer? {
            didSet(oldValue) {
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
            didSet(oldValue) {
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
        public var containers: [IUIModalContentContainer] {
            return self._items.compactMap({ return $0.container })
        }
        public var previous: IUIModalContentContainer? {
            return self._previous?.container
        }
        public var current: IUIModalContentContainer? {
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
        
        public init(
            _ content: (IUIContainer & IUIContainerParentable)? = nil
        ) {
            self.isPresented = false
            self.content = content
            self._layout = Layout(content.flatMap({ UI.Layout.Item($0.view) }))
            self._view = UI.View.Custom(self._layout)
#if os(macOS)
            self.animationVelocity = NSScreen.main!.animationVelocity
#elseif os(iOS)
            self.animationVelocity = Float(max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 3)
            self.interactiveLimit = 20
            self._view.gestures([ self._interactiveGesture ])
#endif
            self._items = []
            self._init()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            let inheritedInsets = self.inheritedInsets(interactive: interactive)
            if let current = self._current?.container {
                if current.modalSheetInset != nil {
                    return InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: inheritedInsets.bottom)
                }
            }
            return inheritedInsets
        }
        
        public func didChangeInsets() {
            self._layout.inset = self.inheritedInsets(interactive: false)
            self.content?.didChangeInsets()
            for container in self.containers {
                container.didChangeInsets()
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
            let item = Item(container: container)
            self._items.append(item)
            if self._current == nil {
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
        
    }
    
}

extension UI.Container.Modal : IUIRootContentContainer {
}

private extension UI.Container.Modal {
    
    func _init() {
#if os(iOS)
        self._interactiveGesture.onShouldRequireFailure({ [unowned self] _, gesture -> Bool in
            guard let view = gesture.view else { return false }
            if let container = self._current?.container {
                return container.view.native.isChild(of: view, recursive: true)
            }
            return false
        }).onShouldBeRequiredToFailBy({ [unowned self] _, gesture -> Bool in
            guard let view = gesture.view else { return false }
            if let container = self.content {
                return container.view.native.isChild(of: view, recursive: true)
            }
            return false
        }).onShouldBegin({ [unowned self] _ in
            guard let current = self._current else { return false }
            guard current.container.shouldInteractive == true else { return false }
            return self._interactiveGesture.contains(in: current.container.view)
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
    
    func _present(current: Item?, next: Item, animated: Bool, completion: (() -> Void)?) {
        if let current = current {
            self._dismiss(modal: current, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self._present(modal: next, animated: animated, completion: completion)
            })
        } else {
            self._present(modal: next, animated: animated, completion: completion)
        }
    }
    
    func _present(modal: Item, animated: Bool, completion: (() -> Void)?) {
        self._current = modal
        if animated == true {
            self._layout.state = .present(modal: modal, progress: .zero)
            modal.container.prepareShow(interactive: false)
            Animation.default.run(
                duration: TimeInterval(self._view.bounds.size.height / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._layout.state = .present(modal: modal, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    modal.container.finishShow(interactive: false)
                    self._layout.state = .idle(modal: modal)
                    completion?()
                }
            )
        } else {
            self._layout.state = .idle(modal: modal)
            modal.container.prepareShow(interactive: false)
            modal.container.finishShow(interactive: false)
            completion?()
        }
    }
    
    func _dismiss(current: Item, previous: Item?, animated: Bool, completion: (() -> Void)?) {
        self._dismiss(modal: current, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            self._current = previous
            if let previous = previous {
                self._present(modal: previous, animated: animated, completion: completion)
            } else {
                completion?()
            }
        })
    }
    
    func _dismiss(modal: Item, animated: Bool, completion: (() -> Void)?) {
        modal.container.prepareHide(interactive: false)
        if animated == true {
            Animation.default.run(
                duration: TimeInterval(self._view.bounds.size.height / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._layout.state = .dismiss(modal: modal, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    modal.container.finishHide(interactive: false)
                    self._layout.state = .empty
                    completion?()
                }
            )
        } else {
            modal.container.finishHide(interactive: false)
            self._layout.state = .empty
            completion?()
        }
    }
    
}

#if os(iOS)

private extension UI.Container.Modal {
    
    func _beginInteractiveGesture() {
        guard let current = self._current else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        current.container.prepareHide(interactive: true)
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._current else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.y - beginLocation.y
        if deltaLocation > 0 {
            let progress = Percent(deltaLocation / self._view.bounds.size.height)
            self._layout.state = .dismiss(modal: current, progress: progress)
        } else {
            self._layout.state = .idle(modal: current)
        }
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._current else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.y - beginLocation.y
        if deltaLocation > self.interactiveLimit {
            let height = self._view.bounds.size.height
            Animation.default.run(
                duration: TimeInterval(height / self.animationVelocity),
                elapsed: TimeInterval(deltaLocation / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._layout.state = .dismiss(modal: current, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._finishInteractiveAnimation()
                }
            )
        } else if deltaLocation > 0 {
            let height = self._view.bounds.size.height
            let baseProgress = Percent(deltaLocation / pow(height, 1.5))
            Animation.default.run(
                duration: TimeInterval((height * baseProgress.value) / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._layout.state = .present(modal: current, progress: .one + (baseProgress - (baseProgress * progress)))
                    self._layout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._cancelInteractiveAnimation()
                }
            )
        } else {
            self._layout.state = .idle(modal: current)
            self._cancelInteractiveAnimation()
        }
    }
    
    func _finishInteractiveAnimation() {
        self._interactiveBeginLocation = nil
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
                self._layout.state = .empty
            }
        } else {
            self._current = nil
            self._layout.state = .empty
        }
    }
    
    func _cancelInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        if let current = self._current {
            current.container.cancelHide(interactive: true)
            self._layout.state = .idle(modal: current)
        } else {
            self._layout.state = .empty
        }
    }
    
}

#endif
