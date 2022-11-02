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
    
    final class Group< Screen : IUIGroupScreen > : IUIGroupContainer, IUIContainerScreenable {
        
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
            return self.current?.shouldInteractive ?? false
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
        public private(set) var bar: UI.View.GroupBar {
            set {
                guard self._bar !== newValue else { return }
                self._bar.delegate = nil
                self._bar = newValue
                self._bar.delegate = self
                self._layout.bar = UI.Layout.Item(self._bar)
            }
            get { self._bar }
        }
        public var barSize: Float {
            get { self._layout.barSize }
        }
        public private(set) var barVisibility: Float {
            set { self._layout.barVisibility = newValue }
            get { self._layout.barVisibility }
        }
        public private(set) var barHidden: Bool {
            set { self._layout.barHidden = newValue }
            get { self._layout.barHidden }
        }
        public var containers: [IUIGroupContentContainer] {
            return self._items.map({ $0.container })
        }
        public var backward: IUIGroupContentContainer? {
            guard let current = self._current else { return nil }
            guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
            return index > 0 ? self._items[index - 1].container : nil
        }
        public var current: IUIGroupContentContainer? {
            return self._current?.container
        }
        public var forward: IUIGroupContentContainer? {
            guard let current = self._current else { return nil }
            guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
            return index < self._items.count - 1 ? self._items[index + 1].container : nil
        }
        public var allowAnimationUserInteraction: Bool = true
        public var animationVelocity: Float
        
        private var _bar: UI.View.GroupBar
        private var _layout: Layout
        private var _view: UI.View.Custom
        private var _items: [Item]
        private var _current: Item?
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            screen: Screen,
            containers: [IUIGroupContentContainer],
            current: IUIGroupContentContainer? = nil
        ) {
            self.isPresented = false
            self.screen = screen
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity
#elseif os(iOS)
            self.animationVelocity = UIScreen.kk_animationVelocity
#endif
            self._bar = screen.groupBar
            self._layout = .init(
                bar: UI.Layout.Item(self._bar),
                barVisibility: screen.groupBarVisibility,
                barHidden: screen.groupBarHidden
            )
            self._view = UI.View.Custom()
                .content(self._layout)
            self._items = containers.map({ Item(container: $0) })
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
                let bottom: Float
                if self.barHidden == false && UI.Container.BarController.shared.hidden(.group) == false {
                    let barSize = self.barSize
                    let barVisibility = self.barVisibility
                    if interactive == true {
                        bottom = barSize * barVisibility
                    } else {
                        bottom = barSize
                    }
                } else {
                    bottom = 0
                }
                return InsetFloat(
                    top: inheritedInsets.top,
                    left: inheritedInsets.left,
                    right: inheritedInsets.right,
                    bottom: inheritedInsets.bottom + bottom
                )
            }
            return inheritedInsets
        }
        
        public func didChangeInsets() {
            let inheritedInsets = self.inheritedInsets(interactive: true)
            if self.barHidden == false {
                self._bar.alpha = self.barVisibility
            } else {
                self._bar.alpha = 0
            }
            self._bar.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
            self._layout.barOffset = inheritedInsets.bottom
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
            self.bar = self.screen.groupBar
            self.barVisibility = self.screen.groupBarVisibility
            self.barHidden = self.screen.groupBarHidden
            self.didChangeInsets()
            completion?()
        }
        
        public func set(containers: [IUIGroupContentContainer], current: IUIGroupContentContainer?, animated: Bool, completion: (() -> Void)?) {
            let oldCurrent = self._current
            let removeItems = self._items.filter({ item in
                return containers.contains(where: { item.container === $0 && oldCurrent?.container !== $0 }) == false
            })
            for item in removeItems {
                item.container.parent = nil
            }
            let inheritedInsets = self.inheritedInsets(interactive: true)
            self._items = containers.map({ Item(container: $0, insets: inheritedInsets) })
            for item in self._items {
                item.container.parent = self
            }
            self._bar.items(self._items.map({ $0.bar }))
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
                } else {
                    completion?()
                }
            } else {
                completion?()
            }
        }
        
        public func set(current: IUIGroupContentContainer, animated: Bool, completion: (() -> Void)?) {
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
                self._set(current: newCurrent, completion: completion)
            }
        }
        
        public func update(container: IUIGroupContentContainer, animated: Bool, completion: (() -> Void)?) {
            guard let item = self._items.first(where: { $0.container === container }) else {
            	completion?()
                return
            }
            item.update()
            self._bar.items(self._items.map({ $0.bar }))
            completion?()
        }
        
    }
    
}

extension UI.Container.Group : IGroupBarViewDelegate {
    
    public func pressed(groupBar: UI.View.GroupBar, item: UI.View.GroupBar.Item) {
        guard let item = self._items.first(where: { $0.bar === item }) else { return }
        if self._current === item {
            _ = self.activate()
        } else {
            self.set(current: item.container, animated: self.allowAnimationUserInteraction, completion: nil)
        }
    }
    
}

extension UI.Container.Group : IUIRootContentContainer {
}

extension UI.Container.Group : IUIStackContentContainer where Screen : IUIScreenStackable {
    
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

extension UI.Container.Group : IUIDialogContentContainer where Screen : IUIScreenDialogable {
    
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

extension UI.Container.Group : IUIHamburgerContentContainer {
}

extension UI.Container.Group : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self._layout.barVisibility = barController.visibility(.group)
    }
    
}

private extension UI.Container.Group {
    
    func _setup() {
        self.screen.container = self
        self._bar.delegate = self
        for item in self._items {
            item.container.parent = self
        }
        self._bar.items(self._items.map({ $0.bar }))
        if let current = self._current {
            self._bar.selected(current.bar)
            self._layout.state = .idle(current: current.groupItem)
        }
        self.screen.setup()
        UI.Container.BarController.shared.add(observer: self)
        if let current = self._current {
            self.screen.change(current: current.container)
        }
    }
    
    func _destroy() {
        UI.Container.BarController.shared.remove(observer: self)
        
        self.screen.container = nil
        self.screen.destroy()
        
        self._animation = nil
    }
    
    func _set(
        current: Item,
        completion: (() -> Void)?
    ) {
        self._bar.selected(current.bar)
        self._layout.state = .idle(current: current.groupItem)
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
                    self._layout.state = .forward(current: current.groupItem, next: forward.groupItem, progress: .zero)
                    if self.isPresented == true {
                        forward.container.didChangeInsets()
                        current.container.prepareHide(interactive: false)
                        forward.container.prepareShow(interactive: false)
                    }
                },
                processing: { [unowned self] progress in
                    self._layout.state = .forward(current: current.groupItem, next: forward.groupItem, progress: progress)
                },
                completion: { [unowned self] in
                    self._animation = nil
                    self._bar.selected(forward.bar)
                    self._layout.state = .idle(current: forward.groupItem)
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
            self._layout.state = .idle(current: forward.groupItem)
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
                    self._layout.state = .backward(current: current.groupItem, next: backward.groupItem, progress: .zero)
                    if self.isPresented == true {
                        backward.container.didChangeInsets()
                        current.container.prepareHide(interactive: false)
                        backward.container.prepareShow(interactive: false)
                    }
                },
                processing: { [unowned self] progress in
                    self._layout.state = .backward(current: current.groupItem, next: backward.groupItem, progress: progress)
                },
                completion: { [unowned self] in
                    self._animation = nil
                    self._bar.selected(backward.bar)
                    self._layout.state = .idle(current: backward.groupItem)
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
            self._layout.state = .idle(current: backward.groupItem)
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
