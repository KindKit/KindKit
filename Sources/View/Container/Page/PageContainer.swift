//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public class PageContainer< Screen : IPageScreen > : IPageContainer, IContainerScreenable {
    
    public unowned var parent: IContainer? {
        didSet(oldValue) {
            guard self.parent !== oldValue else { return }
            self.didChangeInsets()
        }
    }
    public var shouldInteractive: Bool {
        return self.screen.shouldInteractive
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
    public private(set) var barView: IPageBarView {
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
    public var containers: [IPageContentContainer] {
        return self._items.compactMap({ $0.container })
    }
    public var backwardContainer: IPageContentContainer? {
        guard let current = self._current else { return nil }
        guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
        return index > 0 ? self._items[index - 1].container : nil
    }
    public var currentContainer: IPageContentContainer? {
        return self._current?.container
    }
    public var forwardContainer: IPageContentContainer? {
        guard let current = self._current else { return nil }
        guard let index = self._items.firstIndex(where: { $0 === current }) else { return nil }
        return index < self._items.count - 1 ? self._items[index + 1].container : nil
    }
    public var animationVelocity: Float
    #if os(iOS)
    public var interactiveLimit: Float
    #endif
    
    private var _barView: IPageBarView
    private var _view: CustomView< Layout >
    #if os(iOS)
    private var _interactiveGesture: PanGesture
    private var _interactiveBeginLocation: PointFloat?
    private var _interactiveCurrentIndex: Int?
    private var _interactiveBackward: Item?
    private var _interactiveCurrent: Item?
    private var _interactiveForward: Item?
    #endif
    private var _items: [Item]
    private var _current: Item?
    
    public init(
        screen: Screen,
        containers: [IPageContentContainer] = [],
        current: IPageContentContainer? = nil
    ) {
        self.isPresented = false
        self.screen = screen
        #if os(iOS)
        self.animationVelocity = UIScreen.main.animationVelocity
        self.interactiveLimit = Float(UIScreen.main.bounds.width * 0.33)
        #endif
        self._barView = screen.pageBarView
        #if os(iOS)
        self._interactiveGesture = PanGesture()
        self._view = CustomView(
            gestures: [ self._interactiveGesture ],
            contentLayout: Layout(
                barItem: LayoutItem(view: self._barView),
                barVisibility: screen.pageBarVisibility,
                barHidden: screen.pageBarHidden
            )
        )
        #else
        self._view = CustomView(
            contentLayout: Layout(
                barItem: LayoutItem(view: self._barView),
                barInset: 0,
                barVisibility: screen.pageBarVisibility,
                barHidden: screen.pageBarHidden
            )
        )
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
            let top: Float
            if self.barHidden == false && ContainerBarController.shared.hidden(.page) == false {
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
        self._barView.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
        self._view.contentLayout.barOffset = inheritedInsets.top
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
        self.barView = self.screen.pageBarView
        self.barVisibility = self.screen.pageBarVisibility
        self.barHidden = self.screen.pageBarHidden
        self.didChangeInsets()
        completion?()
    }
    
    public func update(container: IPageContentContainer, animated: Bool, completion: (() -> Void)?) {
        guard let item = self._items.first(where: { $0.container === container }) else {
            completion?()
            return
        }
        item.update()
        self._barView.itemViews(self._items.compactMap({ $0.barView }))
    }
    
    public func set(containers: [IPageContentContainer], current: IPageContentContainer?, animated: Bool, completion: (() -> Void)?) {
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
    
    public func set(current: IPageContentContainer, animated: Bool, completion: (() -> Void)?) {
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

extension PageContainer : IPageBarViewDelegate {
    
    public func pressed(pageBar: IPageBarView, itemView: IView) {
        guard let item = self._items.first(where: { $0.barView === itemView }) else { return }
        if self._current === item {
            _ = self.activate()
        } else {
            self.set(current: item.container, animated: true, completion: nil)
        }
    }
    
}

extension PageContainer : IRootContentContainer {
}

extension PageContainer : IStackContentContainer where Screen : IScreenStackable {
    
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

extension PageContainer : IGroupContentContainer where Screen : IScreenGroupable  {
    
    public var groupItemView: IBarItemView {
        return self.screen.groupItemView
    }
    
    public func pressedToGroupItem() -> Bool {
        return false
    }
    
}

extension PageContainer : IDialogContentContainer where Screen : IScreenDialogable {
    
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

extension PageContainer : IContainerBarControllerObserver {
    
    public func changed(containerBarController: ContainerBarController) {
        self._view.contentLayout.barVisibility = containerBarController.visibility(.page)
    }
    
}

private extension PageContainer {
    
    func _init() {
        #if os(iOS)
        self._interactiveGesture.onShouldBegin({ [unowned self] in
            guard let current = self._current else { return false }
            guard self.shouldInteractive == true else { return false }
            guard current.container.shouldInteractive == true else { return false }
            guard self._items.count > 1 else { return false }
            return true
        }).onBegin({ [unowned self] in
            self._beginInteractiveGesture()
        }) .onChange({ [unowned self] in
            self._changeInteractiveGesture()
        }).onCancel({ [unowned self] in
            self._endInteractiveGesture(true)
        }).onEnd({ [unowned self] in
            self._endInteractiveGesture(false)
        })
        #else
        #endif
        self._barView.delegate = self
        self.screen.container = self
        for item in self._items {
            item.container.parent = self
        }
        self._barView.itemViews(self._items.compactMap({ $0.barView }))
        if let current = self._current {
            self._barView.selectedItemView(current.barView)
            self._view.contentLayout.state = .idle(current: current.pageItem)
        }
        self.screen.setup()
    }
    
    func _set(
        current: Item?,
        forward: Item?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let interCompletion: (_ item: Item?) -> Void = { item in
            if let item = item {
                self.screen.change(current: item.container)
            }
            completion?()
        }
        if animated == true {
            if let current = current, let forward = forward {
                Animation.default.run(
                    duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._barView.beginTransition()
                        self._view.contentLayout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: .zero)
                        if self.isPresented == true {
                            current.container.prepareHide(interactive: false)
                            forward.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._barView.transition(to: forward.barView, progress: progress)
                        self._view.contentLayout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress)
                        self._view.contentLayout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._barView.finishTransition(to: forward.barView)
                        self._view.contentLayout.state = .idle(current: forward.pageItem)
                        if self.isPresented == true {
                            current.container.finishHide(interactive: false)
                            forward.container.finishShow(interactive: false)
                        }
                        self.setNeedUpdateOrientations()
                        self.setNeedUpdateStatusBar()
                        interCompletion(forward)
                    }
                )
            } else if let forward = forward {
                self._barView.selectedItemView(forward.barView)
                self._view.contentLayout.state = .idle(current: forward.pageItem)
                if self.isPresented == true {
                    forward.container.prepareShow(interactive: false)
                    forward.container.finishShow(interactive: false)
                }
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(forward)
            } else if let current = current {
                self._barView.selectedItemView(nil)
                self._view.contentLayout.state = .empty
                if self.isPresented == true {
                    current.container.prepareHide(interactive: false)
                    current.container.finishHide(interactive: false)
                }
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(nil)
            } else {
                self._view.contentLayout.state = .empty
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(nil)
            }
        } else if let current = current, let forward = forward {
            self._barView.selectedItemView(forward.barView)
            self._view.contentLayout.state = .idle(current: forward.pageItem)
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
                forward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                forward.container.finishShow(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(forward)
        } else if let forward = forward {
            self._barView.selectedItemView(forward.barView)
            self._view.contentLayout.state = .idle(current: forward.pageItem)
            if self.isPresented == true {
                forward.container.prepareShow(interactive: false)
                forward.container.finishShow(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(forward)
        } else if let current = current {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
                current.container.finishHide(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(nil)
        } else {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(nil)
        }
    }
    
    func _set(
        current: Item?,
        backward: Item?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let interCompletion: (_ item: Item?) -> Void = { item in
            if let item = item {
                self.screen.change(current: item.container)
            }
            completion?()
        }
        if animated == true {
            if let current = current, let backward = backward {
                Animation.default.run(
                    duration: TimeInterval(self._view.contentSize.width / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    preparing: { [weak self] in
                        guard let self = self else { return }
                        self._barView.beginTransition()
                        self._view.contentLayout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: .zero)
                        if self.isPresented == true {
                            current.container.prepareHide(interactive: false)
                            backward.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._barView.transition(to: backward.barView, progress: progress)
                        self._view.contentLayout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress)
                        self._view.contentLayout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._barView.finishTransition(to: backward.barView)
                        self._view.contentLayout.state = .idle(current: backward.pageItem)
                        if self.isPresented == true {
                            current.container.finishHide(interactive: false)
                            backward.container.finishShow(interactive: false)
                        }
                        self.setNeedUpdateOrientations()
                        self.setNeedUpdateStatusBar()
                        interCompletion(backward)
                    }
                )
            } else if let backward = backward {
                self._barView.selectedItemView(backward.barView)
                self._view.contentLayout.state = .idle(current: backward.pageItem)
                if self.isPresented == true {
                    backward.container.prepareShow(interactive: false)
                    backward.container.finishShow(interactive: false)
                }
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(backward)
            } else if let current = current {
                self._barView.selectedItemView(nil)
                self._view.contentLayout.state = .empty
                if self.isPresented == true {
                    current.container.prepareHide(interactive: false)
                    current.container.finishHide(interactive: false)
                }
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(nil)
            } else {
                self._view.contentLayout.state = .empty
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(nil)
            }
        } else if let current = current, let backward = backward {
            self._barView.selectedItemView(backward.barView)
            self._view.contentLayout.state = .idle(current: backward.pageItem)
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
                backward.container.prepareShow(interactive: false)
                current.container.finishHide(interactive: false)
                backward.container.finishShow(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(backward)
        } else if let backward = backward {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .idle(current: backward.pageItem)
            if self.isPresented == true {
                backward.container.prepareShow(interactive: false)
                backward.container.finishShow(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(backward)
        } else if let current = current {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            if self.isPresented == true {
                current.container.prepareHide(interactive: false)
                current.container.finishHide(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(nil)
        } else {
            self._barView.selectedItemView(nil)
            self._view.contentLayout.state = .empty
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(nil)
        }
    }
    
}

#if os(iOS)

private extension PageContainer {
    
    func _beginInteractiveGesture() {
        guard let index = self._items.firstIndex(where: { $0 === self._current }) else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        self._barView.beginTransition()
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
                self._barView.transition(to: forward.barView, progress: progress)
                self._view.contentLayout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress)
            } else {
                self._barView.selectedItemView(current.barView)
                self._view.contentLayout.state = .idle(current: current.pageItem)
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
                self._barView.transition(to: backward.barView, progress: progress)
                self._view.contentLayout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress)
            } else {
                self._barView.selectedItemView(current.barView)
                self._view.contentLayout.state = .idle(current: current.pageItem)
            }
        } else {
            self._barView.selectedItemView(current.barView)
            self._view.contentLayout.state = .idle(current: current.pageItem)
        }
    }

    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.x - beginLocation.x
        let absDeltaLocation = abs(deltaLocation)
        let layoutSize = self._view.contentSize
        if let forward = self._interactiveForward, deltaLocation <= -self.interactiveLimit && canceled == false {
            Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval(absDeltaLocation / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._barView.transition(to: forward.barView, progress: progress)
                    self._view.contentLayout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._finishForwardInteractiveAnimation()
                }
            )
        } else if let backward = self._interactiveBackward, deltaLocation >= self.interactiveLimit && canceled == false {
            Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval(absDeltaLocation / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._barView.transition(to: backward.barView, progress: progress)
                    self._view.contentLayout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._finishBackwardInteractiveAnimation()
                }
            )
        } else if let forward = self._interactiveForward, deltaLocation < 0 {
            Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval((layoutSize.width - absDeltaLocation) / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._barView.transition(to: forward.barView, progress: progress.invert)
                    self._view.contentLayout.state = .forward(current: current.pageItem, next: forward.pageItem, progress: progress.invert)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._cancelInteractiveAnimation()
                }
            )
        } else if let backward = self._interactiveBackward, deltaLocation > 0 {
            Animation.default.run(
                duration: TimeInterval(layoutSize.width / self.animationVelocity),
                elapsed: TimeInterval((layoutSize.width - absDeltaLocation) / self.animationVelocity),
                processing: { [weak self] progress in
                    guard let self = self else { return }
                    self._barView.transition(to: backward.barView, progress: progress.invert)
                    self._view.contentLayout.state = .backward(current: current.pageItem, next: backward.pageItem, progress: progress.invert)
                    self._view.contentLayout.updateIfNeeded()
                },
                completion: { [weak self] in
                    guard let self = self else { return }
                    self._cancelInteractiveAnimation()
                }
            )
        } else {
            self._cancelInteractiveAnimation()
        }
    }
    
    func _finishForwardInteractiveAnimation() {
        if let current = self._interactiveForward {
            self._barView.finishTransition(to: current.barView)
            self._view.contentLayout.state = .idle(current: current.pageItem)
            self._current = current
            self.screen.change(current: current.container)
        }
        self._interactiveForward?.container.finishShow(interactive: true)
        self._interactiveCurrent?.container.finishHide(interactive: true)
        self._interactiveBackward?.container.cancelShow(interactive: true)
        self._resetInteractiveAnimation()
        self.screen.finishInteractiveToForward()
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
    }
    
    func _finishBackwardInteractiveAnimation() {
        if let current = self._interactiveBackward {
            self._barView.finishTransition(to: current.barView)
            self._view.contentLayout.state = .idle(current: current.pageItem)
            self._current = current
            self.screen.change(current: current.container)
        }
        self._interactiveForward?.container.cancelShow(interactive: true)
        self._interactiveCurrent?.container.finishHide(interactive: true)
        self._interactiveBackward?.container.finishShow(interactive: true)
        self._resetInteractiveAnimation()
        self.screen.finishInteractiveToBackward()
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
    }
    
    func _cancelInteractiveAnimation() {
        if let current = self._interactiveCurrent {
            self._barView.finishTransition(to: current.barView)
            self._view.contentLayout.state = .idle(current: current.pageItem)
        }
        self._interactiveForward?.container.cancelShow(interactive: true)
        self._interactiveCurrent?.container.cancelHide(interactive: true)
        self._interactiveBackward?.container.cancelShow(interactive: true)
        self._resetInteractiveAnimation()
        self.screen.cancelInteractive()
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginLocation = nil
        self._interactiveCurrentIndex = nil
        self._interactiveBackward = nil
        self._interactiveCurrent = nil
        self._interactiveForward = nil
    }
    
}
    
#endif

private extension PageContainer {
    
    class Item {
        
        var container: IPageContentContainer
        var barView: IBarItemView {
            return self.barItem.view as! IBarItemView
        }
        var barItem: LayoutItem
        var pageView: IView {
            return self.pageItem.view
        }
        var pageItem: LayoutItem

        init(
            container: IPageContentContainer,
            insets: InsetFloat = .zero
        ) {
            self.container = container
            self.barItem = LayoutItem(view: container.pageItemView)
            self.pageItem = LayoutItem(view: container.view)
        }
        
        func update() {
            self.barItem = LayoutItem(view: self.container.pageItemView)
        }

    }
    
}

private extension PageContainer {
    
    class Layout : ILayout {
        
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
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barItem = barItem
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            let barSize = self.barItem.size(available: SizeFloat(
                width: bounds.width,
                height: .infinity
            ))
            self.barItem.frame = RectFloat(
                x: bounds.origin.x,
                y: bounds.origin.y,
                width: bounds.size.width,
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

private extension PageContainer.Layout {
    
    enum State {
        case empty
        case idle(current: LayoutItem)
        case forward(current: LayoutItem, next: LayoutItem, progress: PercentFloat)
        case backward(current: LayoutItem, next: LayoutItem, progress: PercentFloat)
    }
    
}
