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
    
    final class Stack< Screen : IUIStackScreen > : IUIStackContainer, IUIContainerScreenable {
        
        public unowned var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.didChangeInsets()
                    }
                } else {
                    self.didChangeInsets()
                }
            }
        }
        public var shouldInteractive: Bool {
            return self._current.container.shouldInteractive
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return self._current.container.statusBar
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self._current.container.statusBarAnimation
        }
        public var statusBarHidden: Bool {
            return self._current.container.statusBarHidden
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self._current.container.supportedOrientations
        }
#endif
        public private(set) var isPresented: Bool
        public private(set) var screen: Screen
        public var view: IUIView {
            return self._view
        }
        public var root: IUIStackContentContainer {
            return self._root.container
        }
        public var containers: [IUIStackContentContainer] {
            return self._items.map({ $0.container })
        }
        public var current: IUIStackContentContainer {
            return self._current.container
        }
        public var hidesGroupBarWhenPushed: Bool
        public var animationVelocity: Float
#if os(iOS)
        public var interactiveLimit: Float
#endif
        
        private var _root: Item
        private var _items: [Item] = []
        private var _layout: Layout
        private var _view: UI.View.Custom
#if os(iOS)
        private var _interactiveGesture = UI.Gesture.EdgePan(.left)
        private var _interactiveBeginLocation: PointFloat?
        private var _interactiveGroupBottomBar: Bool = false
        private var _interactiveGroupBarOldVisibility: Float = 1
        private var _interactiveGroupBarNewVisibility: Float = 1
        private var _interactiveBackward: Item?
        private var _interactiveCurrent: Item?
#endif
        @inline(__always)
        private var _current: Item {
            return self._items.last ?? self._root
        }
        private var _animation: IAnimationTask?
        
        public init(
            screen: Screen,
            root: IUIStackContentContainer,
            hidesGroupBarWhenPushed: Bool = false
        ) {
            self.isPresented = false
            self.screen = screen
            self.hidesGroupBarWhenPushed = hidesGroupBarWhenPushed
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity
#elseif os(iOS)
            self.animationVelocity = UIScreen.kk_animationVelocity
            self.interactiveLimit = Float(UIScreen.main.bounds.width * 0.45)
#endif
            self._root = Item(container: root)
            self._layout = Layout(.idle(current: self._root.item))
            self._view = UI.View.Custom(self._layout)
#if os(iOS)
                .gestures([ self._interactiveGesture ])
#endif
            self._setup()
        }
        
        public convenience init<
            RootScreen : IUIScreen & IUIScreenStackable & IUIScreenViewable
        >(
            screen: Screen,
            root: RootScreen,
            hidesGroupBarWhenPushed: Bool = false
        ) {
            self.init(
                screen: screen,
                root: UI.Container.Screen(root),
                hidesGroupBarWhenPushed: hidesGroupBarWhenPushed
            )
        }
        
        deinit {
            self._destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            let inheritedInsets = self.inheritedInsets(interactive: interactive)
            let item: Item?
            if self._root.container === container {
                item = self._root
            } else {
                item = self._items.first(where: { $0.container === container })
            }
            if let item = item {
                let top: Float
                if item.barHidden == false && UI.Container.BarController.shared.hidden(.stack) == false {
                    if interactive == true {
                        top = item.barSize * item.barVisibility
                    } else {
                        top = item.barSize
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
            self._root.set(insets: inheritedInsets)
            self._root.container.didChangeInsets()
            for item in self._items {
                item.set(insets: inheritedInsets)
                item.container.didChangeInsets()
            }
        }
        
        public func activate() -> Bool {
            if self.screen.activate() == true {
                return true
            }
            if self._items.count > 0 {
                self.popToRoot()
                return true
            }
            return self._root.container.activate()
        }
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
            for item in self._items.reversed() {
                item.container.didChangeAppearance()
            }
            self._root.container.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.screen.prepareShow(interactive: interactive)
            self._current.container.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.screen.finishShow(interactive: interactive)
            self._current.container.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.screen.cancelShow(interactive: interactive)
            self._current.container.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.screen.prepareHide(interactive: interactive)
            self._current.container.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.screen.finishHide(interactive: interactive)
            self._current.container.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
            self._current.container.cancelHide(interactive: interactive)
        }
        
        public func update(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?) {
            let item: Item?
            if self._root.container === container {
                item = self._root
            } else {
                item = self._items.first(where: { $0.container === container })
            }
            if let item = item {
                item.update()
            }
            if self.isPresented == true {
                self.didChangeInsets()
            }
            completion?()
        }
        
        public func set(root: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?) {
            let inheritedInsets = self.inheritedInsets(interactive: true)
            let newRootItem = Item(container: root, insets: inheritedInsets)
            newRootItem.container.parent = self
            let oldRootItem = self._root
            self._root = newRootItem
            if self._items.isEmpty == true {
                self._push(current: oldRootItem, forward: newRootItem, animated: animated, completion: {
                    oldRootItem.container.parent = nil
                    completion?()
                })
            } else {
                oldRootItem.container.parent = nil
                completion?()
            }
        }
        
        public func set(containers: [IUIStackContentContainer], animated: Bool, completion: (() -> Void)?) {
            if containers.isEmpty == false {
                let current = self._current
                let removeItems = self._items.filter({ item in
                    return containers.contains(where: { item.container === $0 }) == false
                })
                let inheritedInsets = self.inheritedInsets(interactive: true)
                self._items = containers.map({ container in
                    if let item = self._items.first(where: { $0.container === container }) {
                        return item
                    }
                    return Item(container: container, insets: inheritedInsets)
                })
                for item in self._items {
                    item.container.parent = self
                }
                let forward = self._items[self._items.endIndex - 1]
                if current !== forward {
                    self._push(current: current, forward: forward, animated: animated, completion: {
                        for item in removeItems {
                            item.container.parent = nil
                        }
                        completion?()
                    })
                } else {
                    for item in removeItems {
                        item.container.parent = nil
                    }
                    completion?()
                }
            } else {
                self.popToRoot(animated: animated, completion: completion)
            }
        }
        
        public func push(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard self._items.contains(where: { $0.container === container }) == false else {
                completion?()
                return
            }
            let inheritedInsets = self.inheritedInsets(interactive: true)
            let forward = Item(container: container, insets: inheritedInsets)
            let current = self._current
            self._items.append(forward)
            container.parent = self
            self._push(current: current, forward: forward, animated: animated, completion: completion)
        }
        
        public func push(containers: [IUIStackContentContainer], animated: Bool, completion: (() -> Void)?) {
            let newContainers = containers.filter({ container in
                return self._items.contains(where: { container === $0.container }) == false
            })
            if newContainers.count > 0 {
                let current = self._current
                let inheritedInsets = self.inheritedInsets(interactive: true)
                let items: [Item] = newContainers.map({ Item(container: $0, insets: inheritedInsets) })
                for item in items {
                    item.container.parent = self
                }
                self._items.append(contentsOf: items)
                self._push(current: current, forward: items[items.endIndex - 1], animated: animated, completion: completion)
            } else {
                completion?()
            }
        }
        
        public func push< Wireframe : IUIWireframe >(wireframe: Wireframe, animated: Bool, completion: (() -> Void)?) where Wireframe : AnyObject, Wireframe.Container : IUIStackContentContainer {
            guard self._items.contains(where: { $0.container === wireframe.container }) == false else {
                completion?()
                return
            }
            let inheritedInsets = self.inheritedInsets(interactive: true)
            let forward = Item(container: wireframe.container, owner: wireframe, insets: inheritedInsets)
            let current = self._current
            self._items.append(forward)
            wireframe.container.parent = self
            self._push(current: current, forward: forward, animated: animated, completion: completion)
        }
        
        public func pop(animated: Bool, completion: (() -> Void)?) {
            if self._items.count > 0 {
                let current = self._items.removeLast()
                let backward = self._items.last ?? self._root
                self._pop(current: current, backward: backward, animated: animated, completion: {
                    current.container.parent = nil
                    completion?()
                })
            } else {
                completion?()
            }
        }
        
        public func popTo(container: IUIStackContentContainer, animated: Bool, completion: (() -> Void)?) {
            if self._root.container === container {
                self.popToRoot(animated: animated, completion: completion)
            } else {
                guard let index = self._items.firstIndex(where: { $0.container === container }) else {
                    completion?()
                    return
                }
                if index != self._items.count - 1 {
                    let current = self._items[self._items.endIndex - 1]
                    let backward = self._items[index]
                    let range = index + 1 ..< self._items.endIndex - 1
                    let removing = self._items[range]
                    self._items.removeSubrange(range)
                    self._pop(current: current, backward: backward, animated: animated, completion: {
                        for item in removing {
                            item.container.parent = nil
                        }
                        completion?()
                    })
                } else {
                    completion?()
                }
            }
        }
        
        public func popToRoot(animated: Bool, completion: (() -> Void)?) {
            if self._items.count > 0 {
                let current = self._items[self._items.endIndex - 1]
                let removing = self._items
                self._items.removeAll()
                self._pop(current: current, backward: self._root, animated: animated, completion: {
                    for item in removing {
                        item.container.parent = nil
                    }
                    completion?()
                })
            } else {
                completion?()
            }
        }
        
    }
    
}

extension UI.Container.Stack : IUIRootContentContainer {
}

extension UI.Container.Stack : IUIGroupContentContainer where Screen : IUIScreenGroupable {
    
    public var groupItem: UI.View.GroupBar.Item {
        return self.screen.groupItem
    }
    
}

extension UI.Container.Stack : IUIDialogContentContainer where Screen : IUIScreenDialogable {
    
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

extension UI.Container.Stack : IUIModalContentContainer where Screen : IUIScreenModalable {
    
    public var modalSheetInset: InsetFloat? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.inset
        }
    }
    
    public var modalSheetBackground: (IUIView & IUIViewAlphable)? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.background
        }
    }
    
}

extension UI.Container.Stack : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        let visibility = barController.visibility(.stack)
        for item in self._items {
            item.barVisibility = visibility
        }
    }
    
}

private extension UI.Container.Stack {
    
    func _setup() {
#if os(iOS)
        self._interactiveGesture.onShouldBeRequiredToFailBy({ [unowned self] _, gesture in
            guard let gestureView = gesture.view else { return false }
            return self._view.native.kk_isChild(of: gestureView, recursive: true)
        }).onShouldBegin({ [unowned self] _ in
            guard self._items.count > 0 else { return false }
            guard self.shouldInteractive == true else { return false }
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
        self._root.container.parent = self
        self.screen.container = self
        self.screen.setup()
        
        UI.Container.BarController.shared.add(observer: self)
    }
    
    func _destroy() {
        UI.Container.BarController.shared.remove(observer: self)
        
        self.screen.container = nil
        self.screen.destroy()
        
        self._animation = nil
    }
    
    func _push(
        current: Item,
        forward: Item,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let hideBar: Bool
        let groupBarOldVisibility = UI.Container.BarController.shared.visibility(.group)
        let groupBarNewVisibility: Float = 0.0
        if current === self._root && self.hidesGroupBarWhenPushed == true && groupBarOldVisibility > groupBarNewVisibility {
            hideBar = true
        } else {
            hideBar = false
        }
        if animated == true {
            self._animation = Animation.default.run(
                duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                preparing: { [unowned self] in
                    self._layout.state = .push(current: current.item, forward: forward.item, progress: .zero)
                    if self.isPresented == true {
                        forward.container.didChangeInsets()
                        current.container.prepareHide(interactive: false)
                        forward.container.prepareShow(interactive: false)
                    }
                },
                processing: { [unowned self] progress in
                    self._layout.state = .push(current: current.item, forward: forward.item, progress: progress)
                    self._layout.updateIfNeeded()
                    if hideBar == true {
                        UI.Container.BarController.shared.set(.group, visibility: groupBarOldVisibility.lerp(groupBarNewVisibility, progress: progress))
                    }
                },
                completion: { [unowned self] in
                    self._animation = nil
                    self._layout.state = .idle(current: forward.item)
                    if self.isPresented == true {
                        current.container.finishHide(interactive: false)
                        forward.container.finishShow(interactive: false)
                    }
                    if hideBar == true {
                        UI.Container.BarController.shared.set(.group, visibility: groupBarNewVisibility)
                    }
#if os(iOS)
                    self.setNeedUpdateOrientations()
                    self.setNeedUpdateStatusBar()
#endif
                    completion?()
                }
            )
        } else {
            self._layout.state = .idle(current: forward.item)
            if self.isPresented == true {
                forward.container.didChangeInsets()
                current.container.prepareHide(interactive: false)
                forward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                forward.container.finishShow(interactive: false)
            }
            if hideBar == true {
                UI.Container.BarController.shared.set(.group, visibility: groupBarNewVisibility)
            }
#if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
#endif
            completion?()
        }
    }
    
    func _pop(
        current: Item,
        backward: Item,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let hideBar: Bool
        let groupBarOldVisibility = UI.Container.BarController.shared.visibility(.group)
        let groupBarNewVisibility: Float = 1.0
        if backward === self._root && self.hidesGroupBarWhenPushed == true && groupBarOldVisibility < groupBarNewVisibility {
            hideBar = true
        } else {
            hideBar = false
        }
        if animated == true {
            self._animation = Animation.default.run(
                duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                ease: Animation.Ease.QuadraticInOut(),
                preparing: { [unowned self] in
                    self._layout.state = .pop(backward: backward.item, current: current.item, progress: .zero)
                    if self.isPresented == true {
                        backward.container.didChangeInsets()
                        current.container.prepareHide(interactive: false)
                        backward.container.prepareShow(interactive: false)
                    }
                },
                processing: { [unowned self] progress in
                    self._layout.state = .pop(backward: backward.item, current: current.item, progress: progress)
                    self._layout.updateIfNeeded()
                    if hideBar == true {
                        UI.Container.BarController.shared.set(.group, visibility: groupBarOldVisibility.lerp(groupBarNewVisibility, progress: progress))
                    }
                },
                completion: { [unowned self] in
                    self._animation = nil
                    self._layout.state = .idle(current: backward.item)
                    if self.isPresented == true {
                        current.container.finishHide(interactive: false)
                        backward.container.finishShow(interactive: false)
                    }
                    if hideBar == true {
                        UI.Container.BarController.shared.set(.group, visibility: groupBarNewVisibility)
                    }
#if os(iOS)
                    self.setNeedUpdateOrientations()
                    self.setNeedUpdateStatusBar()
#endif
                    completion?()
                }
            )
        } else {
            self._layout.state = .idle(current: backward.item)
            if self.isPresented == true {
                backward.container.didChangeInsets()
                current.container.prepareHide(interactive: false)
                backward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                backward.container.finishShow(interactive: false)
            }
            if hideBar == true {
                UI.Container.BarController.shared.set(.group, visibility: groupBarNewVisibility)
            }
#if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
#endif
            completion?()
        }
    }
    
}

#if os(iOS)

private extension UI.Container.Stack {
    
    func _beginInteractiveGesture() {
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        let backward = self._items.count > 1 ? self._items[self._items.count - 2] : self._root
        backward.container.prepareShow(interactive: true)
        self._interactiveBackward = backward
        let current = self._items[self._items.count - 1]
        current.container.prepareHide(interactive: true)
        self._interactiveCurrent = current
        if backward === self._root && self.hidesGroupBarWhenPushed == true {
            self._interactiveGroupBottomBar = true
            self._interactiveGroupBarOldVisibility = UI.Container.BarController.shared.visibility(.group)
            self._interactiveGroupBarNewVisibility = 1
        } else {
            self._interactiveGroupBottomBar = false
            self._interactiveGroupBarOldVisibility = 1
            self._interactiveGroupBarNewVisibility = 1
        }
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let backward = self._interactiveBackward, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation - beginLocation
        let layoutSize = self._view.contentSize
        let progress = Percent(max(0, deltaLocation.x / layoutSize.width))
        self._layout.state = .pop(backward: backward.item, current: current.item, progress: progress)
        if self._interactiveGroupBottomBar == true {
            UI.Container.BarController.shared.set(.group, visibility: self._interactiveGroupBarOldVisibility.lerp(self._interactiveGroupBarNewVisibility, progress: progress))
        }
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let backward = self._interactiveBackward, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation - beginLocation
        let layoutSize = self._view.contentSize
        if deltaLocation.x >= self.interactiveLimit && canceled == false {
            self._animation = Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval(deltaLocation.x / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._layout.state = .pop(backward: backward.item, current: current.item, progress: progress)
                    self._layout.updateIfNeeded()
                    if self._interactiveGroupBottomBar == true {
                        UI.Container.BarController.shared.set(.group, visibility: self._interactiveGroupBarOldVisibility.lerp(self._interactiveGroupBarNewVisibility, progress: progress))
                    }
                },
                completion: { [unowned self] in
                    self._finishInteractiveAnimation(backward: backward, current: current)
                }
            )
        } else {
            self._animation = Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval((layoutSize.width - deltaLocation.x) / self.animationVelocity),
                processing: { [unowned self] progress in
                    self._layout.state = .pop(backward: backward.item, current: current.item, progress: progress.invert)
                    self._layout.updateIfNeeded()
                    if self._interactiveGroupBottomBar == true {
                        UI.Container.BarController.shared.set(.group, visibility: self._interactiveGroupBarOldVisibility.lerp(self._interactiveGroupBarNewVisibility, progress: progress.invert))
                    }
                },
                completion: { [unowned self] in
                    self._cancelInteractiveAnimation(backward: backward, current: current)
                }
            )
        }
    }
    
    func _finishInteractiveAnimation(backward: Item, current: Item) {
        self._resetInteractiveAnimation()
        self._items.remove(at: self._items.count - 1)
        self._layout.state = .idle(current: backward.item)
        current.container.finishHide(interactive: true)
        backward.container.finishShow(interactive: true)
        current.container.parent = nil
        if self._interactiveGroupBottomBar == true {
            UI.Container.BarController.shared.set(.group, visibility: self._interactiveGroupBarNewVisibility)
        }
#if os(iOS)
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
#endif
    }
    
    func _cancelInteractiveAnimation(backward: Item, current: Item) {
        self._resetInteractiveAnimation()
        self._layout.state = .idle(current: current.item)
        current.container.cancelHide(interactive: true)
        backward.container.cancelShow(interactive: true)
        if self._interactiveGroupBottomBar == true {
            UI.Container.BarController.shared.set(.group, visibility: self._interactiveGroupBarOldVisibility)
        }
#if os(iOS)
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
#endif
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._interactiveBackward = nil
        self._interactiveCurrent = nil
        self._animation = nil
    }
    
}

#endif
