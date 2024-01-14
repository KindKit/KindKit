//
//  KindKit
//

import KindAnimation
import KindUI

public extension Container {

    final class Book< Screen : IBookScreen > : IBookContainer {
        
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
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                self.current?.didChange(orientation: self.orientation)
                self.backward?.didChange(orientation: self.orientation)
                self.forward?.didChange(orientation: self.orientation)
            }
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
        public var animationVelocity: Double
#if os(iOS)
        public var interactiveLimit: Double
#endif
        
        private var _layout: Layout
        private var _view: CustomView
#if os(iOS)
        private var _interactiveGesture = PanGesture()
        private var _interactiveBeginLocation: Point?
        private var _interactiveCurrentIndex: Int?
        private var _interactiveBackward: BookItem?
        private var _interactiveCurrent: BookItem?
        private var _interactiveForward: BookItem?
#endif
        private var _backward: BookItem?
        private var _current: BookItem?
        private var _forward: BookItem?
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            screen: Screen
        ) {
            self.isPresented = false
            self.screen = screen
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity
#elseif os(iOS)
            self.animationVelocity = UIScreen.kk_animationVelocity
            self.interactiveLimit = Double(UIScreen.main.bounds.width * 0.33)
#endif
            self._layout = Layout()
            self._view = CustomView()
                .content(self._layout)
#if os(iOS)
                .gestures([ self._interactiveGesture ])
#endif
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
            if let item = self._backward {
                item.container.apply(contentInset: contentInset)
            }
            if let item = self._current {
                item.container.apply(contentInset: contentInset)
            }
            if let item = self._forward {
                item.container.apply(contentInset: contentInset)
            }
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> Container.AccumulateInset {
            switch self._layout.state {
            case .empty:
                return .zero
            case .idle(let curr):
                return curr.container.contentInset()
            case .forward(let curr, let next, let progress):
                let currInset = curr.container.contentInset()
                let nextInset = next.container.contentInset()
                return currInset.lerp(nextInset, progress: progress)
            case .backward(let curr, let next, let progress):
                let currInset = curr.container.contentInset()
                let nextInset = next.container.contentInset()
                return currInset.lerp(nextInset, progress: progress)
            }
        }
        
        public func refreshParentInset() {
            if let item = self._backward {
                item.container.refreshParentInset()
            }
            if let item = self._current {
                item.container.refreshParentInset()
            }
            if let item = self._forward {
                item.container.refreshParentInset()
            }
        }
        
        public func activate() -> Bool {
            if let item = self._current {
                return item.container.activate()
            }
            return false
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            if let item = self._current {
                return item.container.snake()
            }
            return false
        }
        
#endif
        
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
        
        public func reload(backward: Bool, forward: Bool) {
            let newBackward: BookItem?
            let newForward: BookItem?
            if let item = self._current {
                if backward == true {
                    newBackward = self.screen.backwardContainer(item.container).flatMap({ BookItem($0) })
                } else {
                    newBackward = nil
                }
                if forward == true {
                    newForward = self.screen.forwardContainer(item.container).flatMap({ BookItem($0) })
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
            guard self._current?.container !== current else {
            	completion?()
                return
            }
            let forward = BookItem(current)
            forward.container.parent = self
            if let current = self._current {
                self._set(current: current, forward: forward, animated: animated, completion: completion)
            } else {
                self._set(current: forward, completion: completion)
            }
        }
        
    }
    
}

extension Container.Book : IStackContentContainer where Screen : IScreenStackable {
    
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

extension Container.Book : IGroupContentContainer where Screen : IScreenGroupable  {
    
    public var groupItem: GroupBarView.Item {
        return self.screen.groupItem
    }
    
    public func pressedToGroupItem() -> Bool {
        return false
    }
    
}

extension Container.Book : IDialogContentContainer where Screen : IScreenDialogable {
    
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

private extension Container.Book {
    
    func _setup() {
#if os(iOS)
        self._interactiveGesture
            .onShouldBegin(self, {
                guard let current = $0._current else { return false }
                guard $0.shouldInteractive == true else { return false }
                guard current.container.shouldInteractive == true else { return false }
                guard $0._backward != nil || $0._forward != nil else { return false }
                return true
            })
            .onBegin(self, { $0._beginInteractiveGesture() })
            .onChange(self, { $0._changeInteractiveGesture() })
            .onCancel(self, { $0._endInteractiveGesture(true) })
            .onEnd(self, { $0._endInteractiveGesture(false) })
#else
#endif
        self.screen.container = self
        let initial = self.screen.initialContainer()
        if let backward = self.screen.backwardContainer(initial) {
            let item = Container.BookItem(backward)
            self._backward = item
            item.container.parent = self
        }
        do {
            let item = Container.BookItem(initial)
            self._current = item
            item.container.parent = self
        }
        if let forward = self.screen.forwardContainer(initial) {
            let item = Container.BookItem(forward)
            self._forward = item
            item.container.parent = self
        }
        if let current = self._current {
            self._layout.state = .idle(current: current)
        } else {
            self._layout.state = .empty
        }
        self.screen.setup()
    }
    
    func _destroy() {
        self.screen.container = nil
        self.screen.destroy()
        
        self._animation = nil
    }
    
    func _set(
        current: Container.BookItem,
        completion: (() -> Void)?
    ) {
        self._layout.state = .idle(current: current)
        if self.isPresented == true {
            current.container.refreshParentInset()
            current.container.prepareShow(interactive: false)
            current.container.finishShow(interactive: false)
        }
        self.refreshContentInset()
#if os(iOS)
        self.refreshOrientations()
        self.refreshStatusBar()
#endif
        self._didSet(
            current: current,
            completion: completion
        )
    }
    
    func _set(
        current: Container.BookItem,
        forward: Container.BookItem,
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
                        self._view.locked = true
                        self._layout.state = .forward(current: current, next: forward, progress: .zero)
                        forward.container.refreshParentInset()
                        current.container.prepareHide(interactive: false)
                        forward.container.prepareShow(interactive: false)
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .forward(current: current, next: forward, progress: progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._view.locked = false
                        self._layout.state = .idle(current: forward)
                        current.container.finishHide(interactive: false)
                        forward.container.finishShow(interactive: false)
                        self.refreshContentInset()
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        self._didSet(
                            current: forward,
                            completion: completion
                        )
                    }
                )
            )
        } else {
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
            self._didSet(
                current: forward,
                completion: completion
            )
        }
    }
    
    func _set(
        current: Container.BookItem,
        backward: Container.BookItem,
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
                        self._view.locked = true
                        self._layout.state = .backward(current: current, next: backward, progress: .zero)
                        backward.container.refreshParentInset()
                        current.container.prepareHide(interactive: false)
                        backward.container.prepareShow(interactive: false)
                    },
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .backward(current: current, next: backward, progress: progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._animation = nil
                        self._view.locked = false
                        self._layout.state = .idle(current: backward)
                        current.container.finishHide(interactive: false)
                        backward.container.finishShow(interactive: false)
                        self.refreshContentInset()
#if os(iOS)
                        self.refreshOrientations()
                        self.refreshStatusBar()
#endif
                        self._didSet(
                            current: backward,
                            completion: completion
                        )
                    }
                )
            )
        } else {
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
            self._didSet(
                current: backward,
                completion: completion
            )
        }
    }
    
    func _didSet(
        current: Container.BookItem,
        completion: (() -> Void)?
    ) {
        let newBackward = self.screen.backwardContainer(current.container).flatMap({ Container.BookItem($0) })
        let newForward = self.screen.forwardContainer(current.container).flatMap({ Container.BookItem($0) })
        self._update(
            newBackward: newBackward,
            newCurrent: current,
            newForward: newForward,
            oldBackward: self._backward,
            oldCurrent: self._current,
            oldForward: self._forward
        )
        self.screen.change(current: current.container)
        completion?()
    }
    
    func _update(
        newBackward: Container.BookItem?,
        newCurrent: Container.BookItem?,
        newForward: Container.BookItem?,
        oldBackward: Container.BookItem?,
        oldCurrent: Container.BookItem?,
        oldForward: Container.BookItem?
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
    
}

#if os(iOS)

private extension Container.Book {
    
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
                self._forward?.container.refreshParentInset()
                self._interactiveForward = self._forward
            }
            if let forward = self._interactiveForward {
                let progress = max(Percent(absDeltaLocation, from: layoutSize.width), .zero)
                self._layout.state = .forward(current: current, next: forward, progress: progress)
            } else {
                self._layout.state = .idle(current: current)
            }
        } else if deltaLocation > 0 {
            if self._backward != nil && self._interactiveBackward == nil {
                self._backward?.container.prepareShow(interactive: true)
                self._backward?.container.refreshParentInset()
                self._interactiveBackward = self._backward
            }
            if let backward = self._interactiveBackward {
                let progress = max(Percent(absDeltaLocation, from: layoutSize.width), .zero)
                self._layout.state = .backward(current: current, next: backward, progress: progress)
            } else {
                self._layout.state = .idle(current: current)
            }
        } else {
            self._layout.state = .idle(current: current)
        }
        self.refreshContentInset()
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let current = self._interactiveCurrent else { return }
        let currentLocation = self._interactiveGesture.location(in: self._view)
        let deltaLocation = currentLocation.x - beginLocation.x
        let absDeltaLocation = abs(deltaLocation)
        let layoutSize = self._view.contentSize
        if let forward = self._interactiveForward, deltaLocation <= -self.interactiveLimit && canceled == false {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(layoutSize.width / self.animationVelocity),
                    elapsed: TimeInterval(absDeltaLocation / self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .forward(current: current, next: forward, progress: progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._finishForwardInteractiveAnimation()
                    }
                )
            )
        } else if let backward = self._interactiveBackward, deltaLocation >= self.interactiveLimit && canceled == false {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(layoutSize.width / self.animationVelocity),
                    elapsed: TimeInterval(absDeltaLocation / self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .backward(current: current, next: backward, progress: progress)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._finishBackwardInteractiveAnimation()
                    }
                )
            )
        } else if let forward = self._interactiveForward, deltaLocation < 0 {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(layoutSize.width / self.animationVelocity),
                    elapsed: TimeInterval((layoutSize.width - absDeltaLocation) / self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .forward(current: current, next: forward, progress: progress.invert)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._cancelInteractiveAnimation()
                    }
                )
            )
        } else if let backward = self._interactiveBackward, deltaLocation > 0 {
            self._animation = KindAnimation.default.run(
                .custom(
                    duration: TimeInterval(layoutSize.width / self.animationVelocity),
                    elapsed: TimeInterval((layoutSize.width - absDeltaLocation) / self.animationVelocity),
                    processing: { [weak self] progress in
                        guard let self = self else { return }
                        self._layout.state = .backward(current: current, next: backward, progress: progress.invert)
                        self._layout.updateIfNeeded()
                        self.refreshContentInset()
                    },
                    completion: { [weak self] in
                        guard let self = self else { return }
                        self._cancelInteractiveAnimation()
                    }
                )
            )
        } else {
            self._cancelInteractiveAnimation()
        }
    }
    
    func _finishForwardInteractiveAnimation() {
        let backward = self._interactiveBackward
        let current = self._interactiveCurrent
        let forward = self._interactiveForward
        self._resetInteractiveAnimation()
        if let current = forward {
            self._layout.state = .idle(current: current)
        }
        forward?.container.finishShow(interactive: true)
        current?.container.finishHide(interactive: true)
        backward?.container.cancelShow(interactive: true)
        if let current = forward {
            self._finishInteractiveAnimation(current: current)
        }
        self.screen.finishInteractiveToForward()
        self.refreshContentInset()
        self.refreshOrientations()
        self.refreshStatusBar()
    }
    
    func _finishBackwardInteractiveAnimation() {
        let backward = self._interactiveBackward
        let current = self._interactiveCurrent
        let forward = self._interactiveForward
        self._resetInteractiveAnimation()
        if let current = backward {
            self._layout.state = .idle(current: current)
        }
        forward?.container.cancelShow(interactive: true)
        current?.container.finishHide(interactive: true)
        backward?.container.finishShow(interactive: true)
        if let current = backward {
            self._finishInteractiveAnimation(current: current)
        }
        self._resetInteractiveAnimation()
        self.screen.finishInteractiveToBackward()
        self.refreshContentInset()
        self.refreshOrientations()
        self.refreshStatusBar()
    }
    
    func _finishInteractiveAnimation(current: Container.BookItem) {
        self._update(
            newBackward: self.screen.backwardContainer(current.container).flatMap({ Container.BookItem($0) }),
            newCurrent: current,
            newForward: self.screen.forwardContainer(current.container).flatMap({ Container.BookItem($0) }),
            oldBackward: self._backward,
            oldCurrent: self._current,
            oldForward: self._forward
        )
        self.screen.change(current: current.container)
    }
    
    func _cancelInteractiveAnimation() {
        let backward = self._interactiveBackward
        let current = self._interactiveCurrent
        let forward = self._interactiveForward
        self._resetInteractiveAnimation()
        if let current = current {
            self._layout.state = .idle(current: current)
        }
        forward?.container.cancelShow(interactive: true)
        current?.container.cancelHide(interactive: true)
        backward?.container.cancelShow(interactive: true)
        self.screen.cancelInteractive()
        self.refreshContentInset()
        self.refreshOrientations()
        self.refreshStatusBar()
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
