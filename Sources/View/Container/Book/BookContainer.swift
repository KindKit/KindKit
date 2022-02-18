//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public class BookContainer< Screen : IBookScreen > : IBookContainer {
    
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
        return self.current?.statusBarHidden ?? false
    }
    public var statusBarStyle: UIStatusBarStyle {
        return self.current?.statusBarStyle ?? .default
    }
    public var statusBarAnimation: UIStatusBarAnimation {
        return self.current?.statusBarAnimation ?? .fade
    }
    public var supportedOrientations: UIInterfaceOrientationMask {
        return self.current?.supportedOrientations ?? .portrait
    }
    #endif
    public private(set) var isPresented: Bool
    public var view: IView {
        return self._view
    }
    public let screen: Screen
    public var backward: IBookContentContainer? {
        return self._backward?.container
    }
    public var current: IBookContentContainer? {
        return self._current?.container
    }
    public var forward: IBookContentContainer? {
        return self._forward?.container
    }
    public var animationVelocity: Float
    #if os(iOS)
    public var interactiveLimit: Float
    #endif
    
    private var _view: CustomView< Layout >
    #if os(iOS)
    private var _interactiveGesture: PanGesture
    private var _interactiveBeginLocation: PointFloat?
    private var _interactiveCurrentIndex: Int?
    private var _interactiveBackward: Item?
    private var _interactiveCurrent: Item?
    private var _interactiveForward: Item?
    #endif
    private var _backward: Item?
    private var _current: Item?
    private var _forward: Item?
    
    public init(
        screen: Screen
    ) {
        self.isPresented = false
        self.screen = screen
        #if os(iOS)
        self.animationVelocity = UIScreen.main.animationVelocity
        self.interactiveLimit = Float(UIScreen.main.bounds.width * 0.33)
        #endif
        #if os(iOS)
        self._interactiveGesture = PanGesture()
        self._view = CustomView(
            gestures: [ self._interactiveGesture ],
            contentLayout: Layout()
        )
        #else
        self._view = CustomView(
            contentLayout: Layout()
        )
        #endif
        self._init()
    }
    
    deinit {
        self.screen.destroy()
    }
    
    public func insets(of container: IContainer, interactive: Bool) -> InsetFloat {
        return self.inheritedInsets(interactive: interactive)
    }
    
    public func didChangeInsets() {
        if let item = self._backward {
            item.container.didChangeInsets()
        }
        if let item = self._current {
            item.container.didChangeInsets()
        }
        if let item = self._forward {
            item.container.didChangeInsets()
        }
    }
    
    public func activate() -> Bool {
        if let item = self._current {
            return item.container.activate()
        }
        return false
    }
    
    public func didChangeAppearance() {
        if let item = self._backward {
            item.container.didChangeAppearance()
        }
        if let item = self._current {
            item.container.didChangeAppearance()
        }
        if let item = self._forward {
            item.container.didChangeAppearance()
        }
    }
    
    public func prepareShow(interactive: Bool) {
        self.didChangeInsets()
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
    
    public func reload(backward: Bool, forward: Bool) {
        let newBackward: Item?
        let newForward: Item?
        if let item = self._current {
            if backward == true {
                newBackward = self.screen.backwardContainer(item.container).flatMap({ Item(container: $0) })
            } else {
                newBackward = nil
            }
            if forward == true {
                newForward = self.screen.forwardContainer(item.container).flatMap({ Item(container: $0) })
            } else {
                newForward = nil
            }
        } else {
            newBackward = nil
            newForward = nil
        }
        self._update(
            newBackward: newBackward ?? self._backward,
            newCurrent: self._current,
            newForward: newForward ?? self._forward,
            oldBackward: self._backward,
            oldCurrent: self._current,
            oldForward: self._forward
        )
    }
    
    public func set(current: IBookContentContainer, animated: Bool, completion: (() -> Void)?) {
        let forward = Item(container: current)
        forward.container.parent = self
        self._set(current: self._current, forward: forward, animated: animated, completion: completion)
    }
    
}

extension BookContainer : IStackContentContainer where Screen : IScreenStackable {
    
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

extension BookContainer : IGroupContentContainer where Screen : IScreenGroupable  {
    
    public var groupItemView: IBarItemView {
        return self.screen.groupItemView
    }
    
    public func pressedToGroupItem() -> Bool {
        return false
    }
    
}

extension BookContainer : IDialogContentContainer where Screen : IScreenDialogable {
    
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

private extension BookContainer {
    
    func _init() {
        #if os(iOS)
        self._interactiveGesture.onShouldBegin({ [unowned self] in
            guard let current = self._current else { return false }
            guard self.shouldInteractive == true else { return false }
            guard current.container.shouldInteractive == true else { return false }
            guard self._backward != nil || self._forward != nil else { return false }
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
        self.screen.container = self
        let initial = self.screen.initialContainer()
        if let backward = self.screen.backwardContainer(initial) {
            let item = Item(container: backward)
            self._backward = item
            item.container.parent = self
        }
        do {
            let item = Item(container: initial)
            self._current = item
            item.container.parent = self
        }
        if let forward = self.screen.forwardContainer(initial) {
            let item = Item(container: forward)
            self._forward = item
            item.container.parent = self
        }
        if let item = self._current {
            self._view.contentLayout.state = .idle(current: item.bookItem)
        } else {
            self._view.contentLayout.state = .empty
        }
        self.screen.setup()
    }
    
    func _update(
        newBackward: Item?,
        newCurrent: Item?,
        newForward: Item?,
        oldBackward: Item?,
        oldCurrent: Item?,
        oldForward: Item?
    ) {
        self._backward = newBackward
        if let item = newBackward {
            if item !== oldBackward && item !== oldCurrent && item !== oldForward {
                item.container.parent = self
            }
        }
        if let item = oldBackward {
            if item !== newBackward && item !== newCurrent && item !== newForward {
                item.container.parent = nil
            }
        }
        self._current = newCurrent
        if let item = newCurrent {
            if item !== oldBackward && item !== oldCurrent && item !== oldForward {
                item.container.parent = self
            }
        }
        if let item = oldCurrent {
            if item !== newBackward && item !== newCurrent && item !== newForward {
                item.container.parent = nil
            }
        }
        self._forward = newForward
        if let item = newForward {
            if item !== oldBackward && item !== oldCurrent && item !== oldForward {
                item.container.parent = self
            }
        }
        if let item = oldForward {
            if item !== newBackward && item !== newCurrent && item !== newForward {
                item.container.parent = nil
            }
        }
    }
    
    func _set(
        current: Item?,
        forward: Item?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let interCompletion: (_ item: Item?) -> Void = { item in
            let newBackward: Item?
            let newForward: Item?
            if let item = item {
                newBackward = self.screen.backwardContainer(item.container).flatMap({ Item(container: $0) })
                newForward = self.screen.forwardContainer(item.container).flatMap({ Item(container: $0) })
            } else {
                newBackward = nil
                newForward = nil
            }
            self._update(
                newBackward: newBackward,
                newCurrent: item,
                newForward: newForward,
                oldBackward: self._backward,
                oldCurrent: self._current,
                oldForward: self._forward
            )
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
                        self._view.contentLayout.state = .forward(current: current.bookItem, next: forward.bookItem, progress: 0)
                        if self.isPresented == true {
                            current.container.prepareHide(interactive: false)
                            forward.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._view.contentLayout.state = .forward(current: current.bookItem, next: forward.bookItem, progress: progress)
                        self._view.contentLayout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._view.contentLayout.state = .idle(current: forward.bookItem)
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
                self._view.contentLayout.state = .idle(current: forward.bookItem)
                if self.isPresented == true {
                    forward.container.prepareShow(interactive: false)
                    forward.container.finishShow(interactive: false)
                }
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(forward)
            } else if let current = current {
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
            self._view.contentLayout.state = .idle(current: forward.bookItem)
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
            self._view.contentLayout.state = .idle(current: forward.bookItem)
            if self.isPresented == true {
                forward.container.prepareShow(interactive: false)
                forward.container.finishShow(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(forward)
        } else if let current = current {
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
    }
    
    func _set(
        current: Item?,
        backward: Item?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let interCompletion: (_ item: Item?) -> Void = { item in
            let newBackward: Item?
            let newForward: Item?
            if let item = item {
                newBackward = self.screen.backwardContainer(item.container).flatMap({ Item(container: $0) })
                newForward = self.screen.forwardContainer(item.container).flatMap({ Item(container: $0) })
            } else {
                newBackward = nil
                newForward = nil
            }
            self._update(
                newBackward: newBackward,
                newCurrent: item,
                newForward: newForward,
                oldBackward: self._backward,
                oldCurrent: self._current,
                oldForward: self._forward
            )
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
                        self._view.contentLayout.state = .backward(current: current.bookItem, next: backward.bookItem, progress: 0)
                        if self.isPresented == true {
                            current.container.prepareHide(interactive: false)
                            backward.container.prepareShow(interactive: false)
                        }
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._view.contentLayout.state = .backward(current: current.bookItem, next: backward.bookItem, progress: progress)
                        self._view.contentLayout.updateIfNeeded()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._view.contentLayout.state = .idle(current: backward.bookItem)
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
                self._view.contentLayout.state = .idle(current: backward.bookItem)
                if self.isPresented == true {
                    backward.container.prepareShow(interactive: false)
                    backward.container.finishShow(interactive: false)
                }
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
                interCompletion(backward)
            } else if let current = current {
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
            self._view.contentLayout.state = .idle(current: backward.bookItem)
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
            self._view.contentLayout.state = .idle(current: backward.bookItem)
            if self.isPresented == true {
                backward.container.prepareShow(interactive: false)
                backward.container.finishShow(interactive: false)
            }
            self.setNeedUpdateOrientations()
            self.setNeedUpdateStatusBar()
            interCompletion(backward)
        } else if let current = current {
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
    }
    
}

#if os(iOS)

private extension BookContainer {
    
    func _beginInteractiveGesture() {
        guard self._interactiveBeginLocation == nil else { return }
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self._view)
        self._current?.container.prepareHide(interactive: true)
        self._interactiveCurrent = self._current
        self.screen.beginInteractive()
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.x - beginLocation.x
        let absDeltaLocation = abs(deltaLocation)
        let layoutSize = self._view.contentSize
        if deltaLocation < 0 {
            if self._forward != nil && self._interactiveForward == nil {
                self._forward?.container.prepareShow(interactive: true)
                self._interactiveForward = self._forward
            }
            if let forward = self._interactiveForward {
                let progress = max(0, absDeltaLocation / layoutSize.width)
                self._view.contentLayout.state = .forward(current: current.bookItem, next: forward.bookItem, progress: progress)
            } else {
                self._view.contentLayout.state = .idle(current: current.bookItem)
            }
        } else if deltaLocation > 0 {
            if self._backward != nil && self._interactiveBackward == nil {
                self._backward?.container.prepareShow(interactive: true)
                self._interactiveBackward = self._backward
            }
            if let backward = self._interactiveBackward {
                let progress = max(0, absDeltaLocation / layoutSize.width)
                self._view.contentLayout.state = .backward(current: current.bookItem, next: backward.bookItem, progress: progress)
            } else {
                self._view.contentLayout.state = .idle(current: current.bookItem)
            }
        } else {
            self._view.contentLayout.state = .idle(current: current.bookItem)
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
                    self._view.contentLayout.state = .forward(current: current.bookItem, next: forward.bookItem, progress: progress)
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
                    self._view.contentLayout.state = .backward(current: current.bookItem, next: backward.bookItem, progress: progress)
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
                    self._view.contentLayout.state = .forward(current: current.bookItem, next: forward.bookItem, progress: 1 - progress)
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
                    self._view.contentLayout.state = .backward(current: current.bookItem, next: backward.bookItem, progress: 1 - progress)
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
            self._view.contentLayout.state = .idle(current: current.bookItem)
        }
        self._interactiveForward?.container.finishShow(interactive: true)
        self._interactiveCurrent?.container.finishHide(interactive: true)
        self._interactiveBackward?.container.cancelShow(interactive: true)
        if let current = self._interactiveForward {
            self._finishInteractiveAnimation(current: current)
        }
        self._resetInteractiveAnimation()
        self.screen.finishInteractiveToForward()
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
    }
    
    func _finishBackwardInteractiveAnimation() {
        if let current = self._interactiveBackward {
            self._view.contentLayout.state = .idle(current: current.bookItem)
        }
        self._interactiveForward?.container.cancelShow(interactive: true)
        self._interactiveCurrent?.container.finishHide(interactive: true)
        self._interactiveBackward?.container.finishShow(interactive: true)
        if let current = self._interactiveBackward {
            self._finishInteractiveAnimation(current: current)
        }
        self._resetInteractiveAnimation()
        self.screen.finishInteractiveToBackward()
        self.setNeedUpdateOrientations()
        self.setNeedUpdateStatusBar()
    }
    
    func _finishInteractiveAnimation(current: Item) {
        self._update(
            newBackward: self.screen.backwardContainer(current.container).flatMap({ Item(container: $0) }),
            newCurrent: current,
            newForward: self.screen.forwardContainer(current.container).flatMap({ Item(container: $0) }),
            oldBackward: self._backward,
            oldCurrent: self._current,
            oldForward: self._forward
        )
        self.screen.change(current: current.container)
    }
    
    func _cancelInteractiveAnimation() {
        if let current = self._interactiveCurrent {
            self._view.contentLayout.state = .idle(current: current.bookItem)
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

private extension BookContainer {
    
    class Item {
        
        var container: IBookContentContainer
        var bookItem: LayoutItem

        init(
            container: IBookContentContainer
        ) {
            self.container = container
            self.bookItem = LayoutItem(view: container.view)
        }

    }
    
}

private extension BookContainer {
    
    class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var state: State {
            didSet { self.setNeedUpdate() }
        }

        init(
            state: State = .empty
        ) {
            self.state = state
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
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
            switch self.state {
            case .empty: return []
            case .idle(let current): return [ current ]
            case .forward(let current, let next, _): return [ current, next ]
            case .backward(let current, let next, _): return [ next, current ]
            }
        }
        
    }
    
}

private extension BookContainer.Layout {
    
    enum State {
        case empty
        case idle(current: LayoutItem)
        case forward(current: LayoutItem, next: LayoutItem, progress: Float)
        case backward(current: LayoutItem, next: LayoutItem, progress: Float)
    }
    
}
