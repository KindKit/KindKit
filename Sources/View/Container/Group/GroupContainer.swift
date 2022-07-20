//
//  KindKitView
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public final class GroupContainer< Screen : IGroupScreen > : IGroupContainer, IContainerScreenable {
    
    public unowned var parent: IContainer? {
        didSet(oldValue) {
            guard self.parent !== oldValue else { return }
            if self.parent == nil || self.parent?.isPresented == true {
                self.didChangeInsets()
            }
        }
    }
    public var shouldInteractive: Bool {
        return self.currentContainer?.shouldInteractive ?? false
    }
    #if os(iOS)
    public var statusBarHidden: Bool {
        return self.currentContainer?.statusBarHidden ?? false
    }
    public var statusBarStyle: UIStatusBarStyle {
        return self.currentContainer?.statusBarStyle ?? .default
    }
    public var statusBarAnimation: UIStatusBarAnimation {
        return self.currentContainer?.statusBarAnimation ?? .fade
    }
    public var supportedOrientations: UIInterfaceOrientationMask {
        return self.currentContainer?.supportedOrientations ?? .portrait
    }
    #endif
    public private(set) var isPresented: Bool
    public var view: IView {
        return self._view
    }
    public private(set) var screen: Screen
    public private(set) var barView: IGroupBarView {
        set(value) {
            guard self._barView !== value else { return }
            self._barView.delegate = nil
            self._barView = value
            self._barView.delegate = self
            self._view.contentLayout.barItem = LayoutItem(view: self._barView)
        }
        get { return self._barView }
    }
    public var barSize: Float {
        get { return self._view.contentLayout.barSize }
    }
    public private(set) var barVisibility: Float {
        set(value) { self._view.contentLayout.barVisibility = value }
        get { return self._view.contentLayout.barVisibility }
    }
    public private(set) var barHidden: Bool {
        set(value) { self._view.contentLayout.barHidden = value }
        get { return self._view.contentLayout.barHidden }
    }
    public var containers: [IGroupContentContainer] {
        return self._items.compactMap({ $0.container })
    }
    public var backwardContainer: IGroupContentContainer? {
        guard let current = self._current else { return nil }
        guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
        return index > 0 ? self._items[index - 1].container : nil
    }
    public var currentContainer: IGroupContentContainer? {
        return self._current?.container
    }
    public var forwardContainer: IGroupContentContainer? {
        guard let current = self._current else { return nil }
        guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
        return index < self._items.count - 1 ? self._items[index + 1].container : nil
    }
    public var animationVelocity: Float
    
    private var _barView: IGroupBarView
    private var _view: CustomView< RootLayout >
    private var _items: [Item]
    private var _current: Item?
    
    public init(
        screen: Screen,
        containers: [IGroupContentContainer],
        current: IGroupContentContainer? = nil
    ) {
        self.isPresented = false
        self.screen = screen
        #if os(macOS)
        self.animationVelocity = NSScreen.main!.animationVelocity
        #elseif os(iOS)
        self.animationVelocity = UIScreen.main.animationVelocity
        #endif
        self._barView = screen.groupBarView
        self._view = CustomView(
            contentLayout: RootLayout(
                barItem: LayoutItem(view: self._barView),
                barVisibility: screen.groupBarVisibility,
                barHidden: screen.groupBarHidden
            )
        )
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
        self._init()
        ContainerBarController.shared.add(observer: self)
    }
    
    deinit {
        ContainerBarController.shared.remove(observer: self)
        self.screen.destroy()
    }
    
    public func insets(of container: IContainer, interactive: Bool) -> InsetFloat {
        let inheritedInsets = self.inheritedInsets(interactive: interactive)
        if self._items.contains(where: { $0.container === container }) == true {
            let bottom: Float
            if self.barHidden == false && ContainerBarController.shared.hidden(.group) == false {
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
            self._barView.alpha = self.barVisibility
        } else {
            self._barView.alpha = 0
        }
        self._barView.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
        self._view.contentLayout.barOffset = inheritedInsets.bottom
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
        self.didChangeInsets()
        self.screen.prepareShow(interactive: interactive)
        self.currentContainer?.prepareShow(interactive: interactive)
    }
    
    public func finishShow(interactive: Bool) {
        self.isPresented = true
        self.screen.finishShow(interactive: interactive)
        self.currentContainer?.finishShow(interactive: interactive)
    }
    
    public func cancelShow(interactive: Bool) {
        self.screen.cancelShow(interactive: interactive)
        self.currentContainer?.cancelShow(interactive: interactive)
    }
    
    public func prepareHide(interactive: Bool) {
        self.screen.prepareHide(interactive: interactive)
        self.currentContainer?.prepareHide(interactive: interactive)
    }
    
    public func finishHide(interactive: Bool) {
        self.isPresented = false
        self.screen.finishHide(interactive: interactive)
        self.currentContainer?.finishHide(interactive: interactive)
    }
    
    public func cancelHide(interactive: Bool) {
        self.screen.cancelHide(interactive: interactive)
        self.currentContainer?.cancelHide(interactive: interactive)
    }
    
    public func updateBar(animated: Bool, completion: (() -> Void)?) {
        self.barView = self.screen.groupBarView
        self.barVisibility = self.screen.groupBarVisibility
        self.barHidden = self.screen.groupBarHidden
        self.didChangeInsets()
        completion?()
    }
    
    public func update(container: IGroupContentContainer, animated: Bool, completion: (() -> Void)?) {
        guard let item = self._items.first(where: { $0.container === container }) else {
            completion?()
            return
        }
        item.update()
        self._barView.itemViews(self._items.compactMap({ $0.barView }))
    }
    
    public func set(containers: [IGroupContentContainer], current: IGroupContentContainer?, animated: Bool, completion: (() -> Void)?) {
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
        self._barView.itemViews(self._items.compactMap({ $0.barView }))
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
            self._set(current: oldCurrent, forward: newCurrent, animated: animated, completion: completion)
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
            self._set(current: nil, forward: newCurrent, animated: animated, completion: completion)
        }
    }
    
}

extension GroupContainer : IGroupBarViewDelegate {
    
    public func pressed(groupBar: IGroupBarView, itemView: IView) {
        guard let item = self._items.first(where: { $0.barView === itemView }) else { return }
        if self._current === item {
            _ = self.activate()
        } else {
            self.set(current: item.container, animated: true, completion: nil)
        }
    }
    
}

extension GroupContainer : IRootContentContainer {
}

extension GroupContainer : IStackContentContainer where Screen : IScreenStackable {
    
    public var stackBarView: IStackBarView {
        return self.screen.stackBarView
    }
    
    public var stackBarVisibility: Float {
        return max(0, min(self.screen.stackBarVisibility, 1))
    }
    
    public var stackBarHidden: Bool {
        return self.screen.stackBarHidden
    }
    
}

extension GroupContainer : IDialogContentContainer where Screen : IScreenDialogable {
    
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
    
    public var dialogBackgroundView: (IView & IViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
}

extension GroupContainer : IHamburgerContentContainer {
}

extension GroupContainer : IContainerBarControllerObserver {
    
    public func changed(containerBarController: ContainerBarController) {
        self._view.contentLayout.barVisibility = containerBarController.visibility(.group)
    }
    
}

private extension GroupContainer {
    
    func _init() {
        self.screen.container = self
        self._barView.delegate = self
        for item in self._items {
            item.container.parent = self
        }
        self._barView.itemViews(self._items.compactMap({ $0.barView }))
        if let current = self._current {
            self._barView.selectedItemView(current.barView)
            self._view.contentLayout.state = .idle(current: current.groupItem)
        }
        self.screen.setup()
    }
    
    func _set(
        current: Item?,
        forward: Item?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if animated == true {
            if let current = current, let forward = forward {
                Animation.default.run(
                    duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._view.contentLayout.state = .forward(current: current.groupItem, next: forward.groupItem, progress: progress)
                        if self.isPresented == true {
                            current.container.prepareHide(interactive: false)
                            forward.container.prepareShow(interactive: false)
                        }
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._barView.selectedItemView(forward.barView)
                        self._view.contentLayout.state = .idle(current: forward.groupItem)
                        if self.isPresented == true {
                            current.container.finishHide(interactive: false)
                            forward.container.finishShow(interactive: false)
                        }
                        #if os(iOS)
                        self.setNeedUpdateOrientations()
                        self.setNeedUpdateStatusBar()
                        #endif
                        completion?()
                    }
                )
            } else if let forward = forward {
                if self.isPresented == true {
                    forward.container.prepareShow(interactive: false)
                }
                self._barView.selectedItemView(forward.barView)
                self._view.contentLayout.state = .idle(current: forward.groupItem)
                if self.isPresented == true {
                    forward.container.finishShow(interactive: false)
                }
                #if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                #endif
                completion?()
            } else if let current = current {
                if self.isPresented == true {
                    current.container.prepareHide(interactive: false)
                }
                self._barView.selectedItemView(nil)
                self._view.contentLayout.state = .empty
                if self.isPresented == true {
                    current.container.finishHide(interactive: false)
                }
                #if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                #endif
                completion?()
            } else {
                self._view.contentLayout.state = .empty
                #if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                #endif
                completion?()
            }
        } else if let current = current, let forward = forward {
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
                forward.container.prepareShow(interactive: false)
            }
            self._barView.selectedItemView(forward.barView)
            self._view.contentLayout.state = .idle(current: forward.groupItem)
            if self.isPresented == true {
                current.container.finishHide(interactive: false)
                forward.container.finishShow(interactive: false)
            }
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        } else if let forward = forward {
            if self.isPresented == true {
                forward.container.prepareShow(interactive: false)
            }
            self._barView.selectedItemView(forward.barView)
            self._view.contentLayout.state = .idle(current: forward.groupItem)
            if self.isPresented == true {
                forward.container.finishShow(interactive: false)
            }
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        } else if let current = current {
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
            }
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            if self.isPresented == true {
                current.container.finishHide(interactive: false)
            }
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        } else {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        }
    }
    
    func _set(
        current: Item?,
        backward: Item?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if animated == true {
            if let current = current, let backward = backward {
                Animation.default.run(
                    duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._view.contentLayout.state = .backward(current: current.groupItem, next: backward.groupItem, progress: progress)
                        if self.isPresented == true {
                            current.container.prepareHide(interactive: false)
                            backward.container.prepareShow(interactive: false)
                        }
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._barView.selectedItemView(backward.barView)
                        self._view.contentLayout.state = .idle(current: backward.groupItem)
                        if self.isPresented == true {
                            current.container.finishHide(interactive: false)
                            backward.container.finishShow(interactive: false)
                        }
                        #if os(iOS)
                        self.setNeedUpdateOrientations()
                        self.setNeedUpdateStatusBar()
                        #endif
                        completion?()
                    }
                )
            } else if let backward = backward {
                if self.isPresented == true {
                    backward.container.prepareShow(interactive: false)
                }
                self._barView.selectedItemView(backward.barView)
                self._view.contentLayout.state = .idle(current: backward.groupItem)
                if self.isPresented == true {
                    backward.container.finishShow(interactive: false)
                }
                #if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                #endif
                completion?()
            } else if let current = current {
                if self.isPresented == true {
                    current.container.prepareHide(interactive: false)
                }
                self._barView.selectedItemView(nil)
                self._view.contentLayout.state = .empty
                if self.isPresented == true {
                    current.container.finishHide(interactive: false)
                }
                #if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                #endif
                completion?()
            } else {
                self._view.contentLayout.state = .empty
                #if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                #endif
                completion?()
            }
        } else if let current = current, let backward = backward {
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
                backward.container.prepareShow(interactive: false)
            }
            self._barView.selectedItemView(backward.barView)
            self._view.contentLayout.state = .idle(current: backward.groupItem)
            if self.isPresented == true {
                current.container.finishHide(interactive: false)
                backward.container.finishShow(interactive: false)
            }
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        } else if let backward = backward {
            if self.isPresented == true {
                backward.container.prepareShow(interactive: false)
            }
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .idle(current: backward.groupItem)
            if self.isPresented == true {
                backward.container.finishShow(interactive: false)
            }
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        } else if let current = current {
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
            }
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            if self.isPresented == true {
                current.container.finishHide(interactive: false)
            }
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        } else {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            #if os(iOS)
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            #endif
            completion?()
        }
    }
    
}

private extension GroupContainer {
    
    final class Item {
        
        var container: IGroupContentContainer
        var barView: IBarItemView {
            return self.barItem.view as! IBarItemView
        }
        var barItem: LayoutItem
        var groupView: IView {
            return self.groupItem.view
        }
        var groupItem: LayoutItem

        init(
            container: IGroupContentContainer,
            insets: InsetFloat = .zero
        ) {
            self.container = container
            self.barItem = LayoutItem(view: container.groupItemView)
            self.groupItem = LayoutItem(view: container.view)
        }
        
        func update() {
            self.barItem = LayoutItem(view: self.container.groupItemView)
        }

    }
    
    final class RootLayout : ILayout {
        
        enum State {
            case empty
            case idle(current: LayoutItem)
            case forward(current: LayoutItem, next: LayoutItem, progress: PercentFloat)
            case backward(current: LayoutItem, next: LayoutItem, progress: PercentFloat)
        }
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var barOffset: Float {
            didSet { self.setNeedUpdate() }
        }
        var barSize: Float
        var barVisibility: Float {
            didSet { self.setNeedUpdate() }
        }
        var barHidden: Bool {
            didSet { self.setNeedUpdate() }
        }
        var barItem: LayoutItem {
            didSet { self.setNeedUpdate() }
        }
        var state: State {
            didSet { self.setNeedUpdate() }
        }

        init(
            barItem: LayoutItem,
            barVisibility: Float,
            barHidden: Bool,
            state: State = .empty
        ) {
            self.barOffset = 0
            self.barSize = 0
            self.barItem = barItem
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let barSize = self.barItem.size(available: SizeFloat(
                width: bounds.width,
                height: .infinity
            ))
            self.barItem.frame = RectFloat(
                bottom: bounds.bottom,
                width: bounds.width,
                height: self.barOffset + (barSize.height * self.barVisibility)
            )
            self.barSize = barSize.height
            let forwardFrame = RectFloat(topLeft: bounds.topRight, size: bounds.size)
            let currentFrame = bounds
            let backwardFrame = RectFloat(topRight: bounds.topLeft, size: bounds.size)
            switch self.state {
            case .empty:
                break
            case .idle(let current):
                current.frame = bounds
            case .forward(let current, let next, let progress):
                current.frame = currentFrame.lerp(backwardFrame, progress: progress)
                next.frame = forwardFrame.lerp(currentFrame, progress: progress)
            case .backward(let current, let next, let progress):
                current.frame = currentFrame.lerp(forwardFrame, progress: progress)
                next.frame = backwardFrame.lerp(currentFrame, progress: progress)
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            var items: [LayoutItem] = []
            if self.barHidden == false {
                items.append(self.barItem)
            }
            switch self.state {
            case .empty: break
            case .idle(let current):
                items.insert(current, at: 0)
            case .forward(let current, let next, _):
                items.insert(contentsOf: [ current, next ], at: 0)
            case .backward(let current, let next, _):
                items.insert(contentsOf: [ next, current ], at: 0)
            }
            return items
        }
        
    }
    
}
