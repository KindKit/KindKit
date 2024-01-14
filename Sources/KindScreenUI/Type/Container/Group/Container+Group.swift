//
//  KindKit
//

import KindAnimation
import KindUI

public extension Container {
    
    final class Group< Screen : IGroupScreen > : IGroupContainer, IContainerScreenable {
        
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
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                for item in self._items {
                    item.container.didChange(orientation: self.orientation)
                }
            }
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IView {
            return self._view
        }
        public private(set) var screen: Screen
        public private(set) var bar: GroupBarView {
            set {
                guard self._bar !== newValue else { return }
                self._bar.delegate = nil
                self._bar = newValue
                self._bar.delegate = self
                self._layout.bar = self._bar
            }
            get { self._bar }
        }
        public var barSize: Double {
            self._layout.barSize
        }
        public private(set) var barVisibility: Double {
            set { self._layout.barVisibility = newValue }
            get { self._layout.barVisibility }
        }
        public private(set) var barHidden: Bool {
            set { self._layout.barHidden = newValue }
            get { self._layout.barHidden }
        }
        public var containers: [IGroupContentContainer] {
            return self._items.map({ $0.container })
        }
        public var backward: IGroupContentContainer? {
            guard let current = self._current else { return nil }
            guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
            return index > 0 ? self._items[index - 1].container : nil
        }
        public var current: IGroupContentContainer? {
            return self._current?.container
        }
        public var forward: IGroupContentContainer? {
            guard let current = self._current else { return nil }
            guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
            return index < self._items.count - 1 ? self._items[index + 1].container : nil
        }
        public var allowAnimationUserInteraction: Bool = true
        public var animationVelocity: Double
        
        private var _bar: GroupBarView
        private var _layout: Layout
        private var _view: CustomView
        private var _items: [Container.GroupItem]
        private var _current: Container.GroupItem?
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            screen: Screen,
            containers: [IGroupContentContainer],
            current: IGroupContentContainer? = nil
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
                bar: self._bar,
                barVisibility: screen.groupBarVisibility,
                barHidden: screen.groupBarHidden
            )
            self._view = CustomView()
                .content(self._layout)
            self._items = containers.map({ Container.GroupItem($0) })
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
        
        public func apply(contentInset: Container.AccumulateInset) {
            for item in self._items {
                item.container.apply(contentInset: contentInset)
            }
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            let parentInset = self.parentInset()
            if self._items.contains(where: { $0.container === container }) == true {
                if self.barHidden == false && Container.BarController.shared.hidden(.group) == false {
                    return parentInset + .init(bottom: self.barSize, visibility: self.barVisibility)
                }
            }
            return parentInset
        }
        
        public func contentInset() -> Container.AccumulateInset {
            let contentInset: Container.AccumulateInset
            switch self._layout.state {
            case .empty:
                contentInset = .zero
            case .idle(let current):
                contentInset = current.container.contentInset()
            case .forward(let current, let next, let progress):
                let currentInset = current.container.contentInset()
                let nextInset = next.container.contentInset()
                contentInset = currentInset.lerp(nextInset, progress: progress)
            case .backward(let current, let next, let progress):
                let currentInset = current.container.contentInset()
                let nextInset = next.container.contentInset()
                contentInset = currentInset.lerp(nextInset, progress: progress)
            }
            if self.barHidden == false && Container.BarController.shared.hidden(.group) == false {
                return contentInset + .init(bottom: self.barSize, visibility: self.barVisibility)
            }
            return contentInset
        }
        
        public func refreshParentInset() {
            let parentInset = self.parentInset()
            if self.barHidden == false {
                self._bar.alpha = self.barVisibility
            } else {
                self._bar.alpha = 0
            }
            self._bar.safeArea(.init(
                top: 0,
                left: parentInset.interactive.left,
                right: parentInset.interactive.right,
                bottom: 0
            ))
            self._layout.barOffset = parentInset.interactive.bottom
            for item in self._items {
                item.container.refreshParentInset()
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
        
#if os(iOS)
        
        public func snake() -> Bool {
            if self.screen.snake() == true {
                return true
            }
            if let current = self._current {
                return current.container.snake()
            }
            return false
        }
        
#endif
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
            for item in self._items {
                item.container.didChangeAppearance()
            }
        }
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
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
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func updateBar(animated: Bool, completion: (() -> Void)?) {
            self.bar = self.screen.groupBar
            self.barVisibility = self.screen.groupBarVisibility
            self.barHidden = self.screen.groupBarHidden
            self.refreshParentInset()
            completion?()
        }
        
        public func set(containers: [IGroupContentContainer], current: IGroupContentContainer?, animated: Bool, completion: (() -> Void)?) {
            let oldCurrent = self._current
            let removeItems = self._items.filter({ item in
                return containers.contains(where: { item.container === $0 && oldCurrent?.container !== $0 }) == false
            })
            for item in removeItems {
                item.container.parent = nil
            }
            let parentInset = self.parentInset()
            self._items = containers.map({ Container.GroupItem($0, parentInset.interactive) })
            for item in self._items {
                item.container.parent = self
            }
            self._bar.items(self._items.map({ $0.bar }))
            let newCurrent: Container.GroupItem?
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
        
        public func set(current: IGroupContentContainer, animated: Bool, completion: (() -> Void)?) {
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
        
        public func update(container: IGroupContentContainer, animated: Bool, completion: (() -> Void)?) {
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

extension Container.Group : IGroupBarViewDelegate {
    
    public func pressed(groupBar: GroupBarView, item: GroupBarView.Item) {
        guard let item = self._items.first(where: { $0.bar === item }) else { return }
        if self._current === item {
            _ = self.activate()
        } else {
            self.set(current: item.container, animated: self.allowAnimationUserInteraction, completion: nil)
        }
    }
    
}

extension Container.Group : IRootContentContainer {
}

extension Container.Group : IStackContentContainer where Screen : IScreenStackable {
    
    public var stackBar: StackBarView {
        return self.screen.stackBar
    }
    
    public var stackBarVisibility: Double {
        return max(0, min(self.screen.stackBarVisibility, 1))
    }
    
    public var stackBarHidden: Bool {
        return self.screen.stackBarHidden
    }
    
}

extension Container.Group : IDialogContentContainer where Screen : IScreenDialogable {
    
    public var dialogInset: Inset {
        return self.screen.dialogInset
    }
    
    public var dialogSize: Dialog.Size {
        return self.screen.dialogSize
    }
    
    public var dialogAlignment: Dialog.Alignment {
        return self.screen.dialogAlignment
    }
    
    public var dialogBackground: (IView & IViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
    public func dialogPressedOutside() {
        self.screen.dialogPressedOutside()
    }
    
}

extension Container.Group : IHamburgerContentContainer {
}

extension Container.Group : IContainerBarControllerObserver {
    
    public func changed(_ barController: Container.BarController) {
        self._layout.barVisibility = barController.visibility(.group)
    }
    
}

private extension Container.Group {
    
    func _setup() {
        self.screen.container = self
        self._bar.delegate = self
        for item in self._items {
            item.container.parent = self
        }
        self._bar.items(self._items.map({ $0.bar }))
        if let current = self._current {
            self._bar.selected(current.bar)
            self._layout.state = .idle(current: current)
        }
        self.screen.setup()
        Container.BarController.shared.add(observer: self)
        if let current = self._current {
            self.screen.change(current: current.container)
        }
    }
    
    func _destroy() {
        Container.BarController.shared.remove(observer: self)
        
        self.screen.container = nil
        self.screen.destroy()
        
        self._animation = nil
    }
    
    func _set(
        current: Container.GroupItem,
        completion: (() -> Void)?
    ) {
        self._bar.selected(current.bar)
        self._layout.state = .idle(current: current)
        if self.isPresented == true {
            current.container.refreshParentInset()
            current.container.prepareShow(interactive: false)
            current.container.finishShow(interactive: false)
        }
#if os(iOS)
        self.refreshOrientations()
        self.refreshStatusBar()
#endif
        self.screen.change(current: current.container)
        completion?()
    }
    
    func _set(
        current: Container.GroupItem,
        forward: Container.GroupItem,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if self.isPresented == true && animated == true {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                    ease: KindAnimation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._layout.state = .forward(current: current, next: forward, progress: .zero)
                        if self.isPresented == true {
                            forward.container.refreshParentInset()
                            current.container.prepareHide(interactive: false)
                            forward.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .forward(current: current, next: forward, progress: progress)
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._bar.selected(forward.bar)
                        self._layout.state = .idle(current: forward)
                        current.container.finishHide(interactive: false)
                        forward.container.finishShow(interactive: false)
                        self.refreshContentInset()
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        self.screen.change(current: forward.container)
                        completion?()
                    }
                )
            )
        } else {
            self._bar.selected(forward.bar)
            self._layout.state = .idle(current: forward)
            if self.isPresented == true {
                forward.container.refreshParentInset()
                current.container.prepareHide(interactive: false)
                forward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                forward.container.finishShow(interactive: false)
            }
            self.refreshContentInset()
#if os(iOS)
            self.refreshOrientations()
            self.refreshStatusBar()
#endif
            self.screen.change(current: forward.container)
            completion?()
        }
    }
    
    func _set(
        current: Container.GroupItem,
        backward: Container.GroupItem,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if self.isPresented == true && animated == true {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                    ease: KindAnimation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._layout.state = .backward(current: current, next: backward, progress: .zero)
                        if self.isPresented == true {
                            backward.container.refreshParentInset()
                            current.container.prepareHide(interactive: false)
                            backward.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .backward(current: current, next: backward, progress: progress)
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._bar.selected(backward.bar)
                        self._layout.state = .idle(current: backward)
                        current.container.finishHide(interactive: false)
                        backward.container.finishShow(interactive: false)
                        self.refreshContentInset()
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        self.screen.change(current: backward.container)
                        completion?()
                    }
                )
            )
        } else {
            self._bar.selected(backward.bar)
            self._layout.state = .idle(current: backward)
            if self.isPresented == true {
                backward.container.refreshParentInset()
                current.container.prepareHide(interactive: false)
                backward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                backward.container.finishShow(interactive: false)
            }
            self.refreshContentInset()
#if os(iOS)
            self.refreshOrientations()
            self.refreshStatusBar()
#endif
            self.screen.change(current: backward.container)
            completion?()
        }
    }
    
}
