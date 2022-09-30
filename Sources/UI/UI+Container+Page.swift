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
    
    final class Page< Screen : IUIPageScreen > : IUIPageContainer, IUIContainerScreenable {
        
        public unowned var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
                }
            }
        }
        public var shouldInteractive: Bool {
            return self.screen.shouldInteractive
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return self.current?.statusBar ?? .default
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self.current?.statusBarAnimation ?? .fade
        }
        public var statusBarHidden: Bool {
            return self.current?.statusBarHidden ?? false
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self.current?.supportedOrientations ?? .portrait
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public private(set) var screen: Screen
        public private(set) var bar: UI.View.PageBar {
            set {
                guard self._bar !== newValue else { return }
                self._bar.delegate = nil
                self._bar = newValue
                self._bar.delegate = self
                self._layout.bar = UI.Layout.Item(self._bar)
            }
            get { return self._bar }
        }
        public var barSize: Float {
            get { return self._layout.barSize }
        }
        public private(set) var barVisibility: Float {
            set { self._layout.barVisibility = newValue }
            get { return self._layout.barVisibility }
        }
        public private(set) var barHidden: Bool {
            set { self._layout.barHidden = newValue }
            get { return self._layout.barHidden }
        }
        public var containers: [IUIPageContentContainer] {
            return self._items.compactMap({ $0.container })
        }
        public var backward: IUIPageContentContainer? {
            guard let current = self._current else { return nil }
            guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
            return index > 0 ? self._items[index - 1].container : nil
        }
        public var current: IUIPageContentContainer? {
            return self._current?.container
        }
        public var forward: IUIPageContentContainer? {
            guard let current = self._current else { return nil }
            guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
            return index < self._items.count - 1 ? self._items[index + 1].container : nil
        }
        public var animationVelocity: Float
#if os(iOS)
        public var interactiveLimit: Float
#endif
        
        private var _bar: UI.View.PageBar
        private var _layout: Layout
        private var _view: UI.View.Custom
#if os(iOS)
        private var _interactiveGesture = UI.Gesture.Pan()
        private var _interactiveBeginLocation: PointFloat?
        private var _interactiveCurrentIndex: Int?
        private var _interactiveBackward: Item?
        private var _interactiveCurrent: Item?
        private var _interactiveForward: Item?
#endif
        private var _items: [Item]
        private var _current: Item?
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            screen: Screen,
            containers: [IUIPageContentContainer] = [],
            current: IUIPageContentContainer? = nil
        ) {
            self.isPresented = false
            self.screen = screen
            self._bar = screen.pageBar
            self._layout = Layout(
                bar: UI.Layout.Item(self._bar),
                barVisibility: screen.pageBarVisibility,
                barHidden: screen.pageBarHidden
            )
            self._view = UI.View.Custom(self._layout)
#if os(macOS)
            self.animationVelocity = NSScreen.main!.animationVelocity
#elseif os(iOS)
            self.animationVelocity = UIScreen.main.animationVelocity
            self.interactiveLimit = Float(UIScreen.main.bounds.width * 0.33)
            self._view.gestures([ self._interactiveGesture ])
#endif
            self._items = containers.compactMap({ Item(container: $0) })
            if let current = current {
                if let index = self._items.firstIndex(where: { $0.container === current }) {
                    self._current = self._items[index]
                } else {
                    self._current = self._items.first
                }
            } else {
                self._current = self._items.first
            }
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            let inheritedInsets = self.inheritedInsets(interactive: interactive)
            if self._items.contains(where: { $0.container === container }) == true {
                let top: Float
                if self.barHidden == false && UI.Container.BarController.shared.hidden(.page) == false {
                    let barSize = self.barSize
                    let barVisibility = self.barVisibility
                    if interactive == true {
                        top = barSize * barVisibility
                    } else {
                        top = barSize
                    }
                } else {
                    top = 0
                }
                return InsetFloat(
                    top: inheritedInsets.top + top,
                    left: inheritedInsets.left,
                    right: inheritedInsets.right,
                    bottom: inheritedInsets.bottom
                )
            }
            return inheritedInsets
        }
        
        public func didChangeInsets() {
            let inheritedInsets = self.inheritedInsets(interactive: true)
            self._bar.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
            self._layout.barOffset = inheritedInsets.top
            for item in self._items {
                item.container.didChangeInsets()
            }
        }
        
        public func activate() -> Bool {
            if self.screen.activate() == true {
                return true
            }
            if let current = self._current {
                return current.container.activate()
            }
            return false
        }
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
            for item in self._items {
                item.container.didChangeAppearance()
            }
        }
        
        public func prepareShow(interactive: Bool) {
            self.screen.prepareShow(interactive: interactive)
            self.current?.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.screen.finishShow(interactive: interactive)
            self.current?.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.screen.cancelShow(interactive: interactive)
            self.current?.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.screen.prepareHide(interactive: interactive)
            self.current?.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.screen.finishHide(interactive: interactive)
            self.current?.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
            self.current?.cancelHide(interactive: interactive)
        }
        
        public func updateBar(animated: Bool, completion: (() -> Void)?) {
            self.bar = self.screen.pageBar
            self.barVisibility = self.screen.pageBarVisibility
            self.barHidden = self.screen.pageBarHidden
            if self.isPresented == true {
                self.didChangeInsets()
            }
            completion?()
        }
        
        public func update(container: IUIPageContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard let item = self._items.first(where: { $0.container === container }) else {
                completion?()
                return
            }
            item.update()
            self._bar.items(self._items.compactMap({ $0.bar }))
        }
        
        public func set(containers: [IUIPageContentContainer], current: IUIPageContentContainer?, animated: Bool, completion: (() -> Void)?) {
            let oldCurrent = self._current
            let removeItems = self._items.filter({ item in
                return containers.contains(where: { item.container === $0 && oldCurrent?.container !== $0 }) == false
            })
            for item in removeItems {
                item.container.parent = nil
            }
            let inheritedInsets = self.inheritedInsets(interactive: true)
            self._items = containers.compactMap({ Item(container: $0, insets: inheritedInsets) })
            for item in self._items {
                item.container.parent = self
            }
            self._bar.items(self._items.compactMap({ $0.bar }))
            let newCurrent: Item?
            if current != nil {
                if let exist = self._items.first(where: { $0.container === current }) {
                    newCurrent = exist
                } else {
                    newCurrent = self._items.first
                }
            } else {
                newCurrent = self._items.first
            }
            if oldCurrent !== newCurrent {
                self._current = newCurrent
                if let newCurrent = newCurrent {
                    if let oldCurrent = oldCurrent {
                        self._set(current: oldCurrent, forward: newCurrent, animated: animated, completion: completion)
                    } else {
                        self._set(current: newCurrent, completion: completion)
                    }
                }
            } else {
                completion?()
            }
        }
        
        public func set(current: IUIPageContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard let newIndex = self._items.firstIndex(where: { $0.container === current }) else {
                completion?()
                return
            }
            let newCurrent = self._items[newIndex]
            if let oldCurrent = self._current {
                if oldCurrent !== newCurrent {
                    self._current = newCurrent
                    let oldIndex = self._items.firstIndex(where: { $0 === oldCurrent })!
                    if newIndex > oldIndex {
                        self._set(current: oldCurrent, forward: newCurrent, animated: animated, completion: completion)
                    } else {
                        self._set(current: oldCurrent, backward: newCurrent, animated: animated, completion: completion)
                    }
                } else {
                    completion?()
                }
            } else {
                self._current = newCurrent
                self._set(current: newCurrent, completion: completion)
            }
        }
        
    }
    
}

extension UI.Container.Page : IPageBarViewDelegate {
    
    public func pressed(pageBar: UI.View.PageBar, item: UI.View.PageBar.Item) {
        guard let item = self._items.first(where: { $0.bar === item }) else { return }
        if self._current === item {
            _ = self.activate()
        } else {
            self.set(current: item.container, animated: true, completion: nil)
        }
    }
    
}

extension UI.Container.Page : IUIRootContentContainer {
}

extension UI.Container.Page : IUIStackContentContainer where Screen : IUIScreenStackable {
    
    public var stackBar: UI.View.StackBar {
        return self.screen.stackBar
    }
    
    public var stackBarVisibility: Float {
        return max(0, min(self.screen.stackBarVisibility, 1))
    }
    
    public var stackBarHidden: Bool {
        return self.screen.stackBarHidden
    }
    
}

extension UI.Container.Page : IUIGroupContentContainer where Screen : IUIScreenGroupable  {
    
    public var groupItem: UI.View.GroupBar.Item {
        return self.screen.groupItem
    }
    
    public func pressedToGroupItem() -> Bool {
        return false
    }
    
}

extension UI.Container.Page : IUIDialogContentContainer where Screen : IUIScreenDialogable {
    
    public var dialogInset: InsetFloat {
        return self.screen.dialogInset
    }
    
    public var dialogWidth: DialogContentContainerSize {
        return self.screen.dialogWidth
    }
    
    public var dialogHeight: DialogContentContainerSize {
        return self.screen.dialogHeight
    }
    
    public var dialogAlignment: DialogContentContainerAlignment {
        return self.screen.dialogAlignment
    }
    
    public var dialogBackground: (IUIView & IUIViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
}

extension UI.Container.Page : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self._layout.barVisibility = barController.visibility(.page)
    }
    
}

private extension UI.Container.Page {
    
    func _setup() {
#if os(iOS)
        self._interactiveGesture.onShouldBegin({ [unowned self] _ in
            guard let current = self._current else { return false }
            guard self.shouldInteractive == true else { return false }
            guard current.container.shouldInteractive == true else { return false }
            guard self._items.count > 1 else { return false }
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
#else
#endif
        self._bar.delegate = self
        self.screen.container = self
        for item in self._items {
            item.container.parent = self
        }
        self._bar.items(self._items.compactMap({ $0.bar }))
        if let current = self._current {
            self._bar.selected(current.bar)
            self._layout.state = .idle(current: current.pageItem)
        }
        self.screen.setup()
        UI.Container.BarController.shared.add(observer: self)
    }
    
    func _destroy() {
        UI.Container.BarController.shared.remove(observer: self)
        
        self.screen.container = nil
        self.screen.destroy()
        
        self._bar.delegate = nil
        self._animation = nil
    }
    
    func _set(
        current: Item,
        completion: (() -> Void)?
    ) {
        self._bar.selected(current.bar)
        self._layout.state = .idle(current: current.pageItem)
        if self.isPresented == true {
            current.container.didChangeInsets()
            current.container.prepareShow(interactive: false)
            current.container.finishShow(interactive: false)
        }
#if os(iOS)
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
#endif
        self.screen.change(current: current.container)
        completion?()
    }
    
    func _set(
        current: Item,
        forward: Item,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if animated == true {
            self._animation = Animation.default.run(
                duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                preparing: { [unowned self] in
                    self._bar.beginTransition()
                    self._layout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: .zero)
                    if self.isPresented == true {
                        forward.container.didChangeInsets()
                        current.container.prepareHide(interactive: false)
                        forward.container.prepareShow(interactive: false)
                    }
                },
                processing: { [unowned self] progress in
                    self._bar.transition(to: forward.bar, progress: progress)
                    self._layout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._animation = nil
                    self._bar.finishTransition(to: forward.bar)
                    self._layout.state = .idle(current: forward.pageItem)
                    if self.isPresented == true {
                        current.container.finishHide(interactive: false)
                        forward.container.finishShow(interactive: false)
                    }
#if os(iOS)
                    self.setNeedUpdateOrientations()
                    self.setNeedUpdateStatusBar()
#endif
                    self.screen.change(current: forward.container)
                    completion?()
                }
            )
        } else {
            self._bar.selected(forward.bar)
            self._layout.state = .idle(current: forward.pageItem)
            if self.isPresented == true {
                forward.container.didChangeInsets()
                current.container.prepareHide(interactive: false)
                forward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                forward.container.finishShow(interactive: false)
            }
#if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
#endif
            self.screen.change(current: forward.container)
            completion?()
        }
    }
    
    func _set(
        current: Item,
        backward: Item,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if animated == true {
            self._animation = Animation.default.run(
                duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                preparing: { [unowned self] in
                    self._bar.beginTransition()
                    self._layout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: .zero)
                    if self.isPresented == true {
                        backward.container.didChangeInsets()
                        current.container.prepareHide(interactive: false)
                        backward.container.prepareShow(interactive: false)
                    }
                },
                processing: { [unowned self] progress in
                    self._bar.transition(to: backward.bar, progress: progress)
                    self._layout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._animation = nil
                    self._bar.finishTransition(to: backward.bar)
                    self._layout.state = .idle(current: backward.pageItem)
                    if self.isPresented == true {
                        current.container.finishHide(interactive: false)
                        backward.container.finishShow(interactive: false)
                    }
#if os(iOS)
                    self.setNeedUpdateOrientations()
                    self.setNeedUpdateStatusBar()
#endif
                    self.screen.change(current: backward.container)
                    completion?()
                }
            )
        } else {
            self._bar.selected(backward.bar)
            self._layout.state = .idle(current: backward.pageItem)
            if self.isPresented == true {
                backward.container.didChangeInsets()
                current.container.prepareHide(interactive: false)
                backward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                backward.container.finishShow(interactive: false)
            }
#if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
#endif
            self.screen.change(current: backward.container)
            completion?()
        }
    }
    
}

#if os(iOS)

private extension UI.Container.Page {
    
    func _beginInteractiveGesture() {
        guard let index = self._items.firstIndex(where: { $0 === self._current }) else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        self._bar.beginTransition()
        self._interactiveCurrentIndex = index
        let current = self._items[index]
        current.container.prepareHide(interactive: true)
        self._interactiveCurrent = current
        self.screen.beginInteractive()
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.x - beginLocation.x
        let absDeltaLocation = abs(deltaLocation)
        let layoutSize = self._view.contentSize
        if deltaLocation < 0 {
            if let index = self._interactiveCurrentIndex, self._interactiveForward == nil {
                if let forward = index < self._items.count - 1 ? self._items[index + 1] : nil {
                    forward.container.prepareShow(interactive: true)
                    self._interactiveForward = forward
                }
            }
            if let forward = self._interactiveForward {
                let progress = Percent(max(0, absDeltaLocation / layoutSize.width))
                self._bar.transition(to: forward.bar, progress: progress)
                self._layout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress)
            } else {
                self._bar.selected(current.bar)
                self._layout.state = .idle(current: current.pageItem)
            }
        } else if deltaLocation > 0 {
            if let index = self._interactiveCurrentIndex, self._interactiveBackward == nil {
                if let backward = index > 0 ? self._items[index - 1] : nil {
                    backward.container.prepareShow(interactive: true)
                    self._interactiveBackward = backward
                }
            }
            if let backward = self._interactiveBackward {
                let progress = Percent(max(0, absDeltaLocation / layoutSize.width))
                self._bar.transition(to: backward.bar, progress: progress)
                self._layout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress)
            } else {
                self._bar.selected(current.bar)
                self._layout.state = .idle(current: current.pageItem)
            }
        } else {
            self._bar.selected(current.bar)
            self._layout.state = .idle(current: current.pageItem)
        }
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.x - beginLocation.x
        let absDeltaLocation = abs(deltaLocation)
        let layoutSize = self._view.contentSize
        if let forward = self._interactiveForward, deltaLocation <= -self.interactiveLimit && canceled == false {
            self._animation = Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval(absDeltaLocation / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._bar.transition(to: forward.bar, progress: progress)
                    self._layout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._finishForwardInteractiveAnimation()
                }
            )
        } else if let backward = self._interactiveBackward, deltaLocation >= self.interactiveLimit && canceled == false {
            self._animation = Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval(absDeltaLocation / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._bar.transition(to: backward.bar, progress: progress)
                    self._layout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._finishBackwardInteractiveAnimation()
                }
            )
        } else if let forward = self._interactiveForward, deltaLocation < 0 {
            self._animation = Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval((layoutSize.width - absDeltaLocation) / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._bar.transition(to: forward.bar, progress: progress.invert)
                    self._layout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress.invert)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._cancelInteractiveAnimation()
                }
            )
        } else if let backward = self._interactiveBackward, deltaLocation > 0 {
            self._animation = Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval((layoutSize.width - absDeltaLocation) / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._bar.transition(to: backward.bar, progress: progress.invert)
                    self._layout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress.invert)
                    self._layout.updateIfNeeded()
                },
                completion: { [unowned self] in
                    self._cancelInteractiveAnimation()
                }
            )
        } else {
            self._cancelInteractiveAnimation()
        }
    }
    
    func _finishForwardInteractiveAnimation() {
        self._resetInteractiveAnimation()
        if let current = self._interactiveForward {
            self._bar.finishTransition(to: current.bar)
            self._layout.state = .idle(current: current.pageItem)
            self._current = current
            self.screen.change(current: current.container)
        }
        self._interactiveForward?.container.finishShow(interactive: true)
        self._interactiveCurrent?.container.finishHide(interactive: true)
        self._interactiveBackward?.container.cancelShow(interactive: true)
        self.screen.finishInteractiveToForward()
#if os(iOS)
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
#endif
    }
    
    func _finishBackwardInteractiveAnimation() {
        let backward = self._interactiveBackward
        let current = self._interactiveCurrent
        let forward = self._interactiveForward
        self._resetInteractiveAnimation()
        if let current = backward {
            self._bar.finishTransition(to: current.bar)
            self._layout.state = .idle(current: current.pageItem)
            self._current = current
            self.screen.change(current: current.container)
        }
        forward?.container.cancelShow(interactive: true)
        current?.container.finishHide(interactive: true)
        backward?.container.finishShow(interactive: true)
        self.screen.finishInteractiveToBackward()
#if os(iOS)
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
#endif
    }
    
    func _cancelInteractiveAnimation() {
        let backward = self._interactiveBackward
        let current = self._interactiveCurrent
        let forward = self._interactiveForward
        self._resetInteractiveAnimation()
        if let current = current {
            self._bar.finishTransition(to: current.bar)
            self._layout.state = .idle(current: current.pageItem)
        }
        forward?.container.cancelShow(interactive: true)
        current?.container.cancelHide(interactive: true)
        backward?.container.cancelShow(interactive: true)
        self.screen.cancelInteractive()
#if os(iOS)
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
#endif
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._interactiveCurrentIndex = nil
        self._interactiveBackward = nil
        self._interactiveCurrent = nil
        self._interactiveForward = nil
        self._animation = nil
    }
    
}

#endif
