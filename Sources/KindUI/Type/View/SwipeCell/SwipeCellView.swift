//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindAnimation
import KindEvent
import KindMath

public final class SwipeCellView : IWidgetView {
    
    public let body: CustomView
    public var shouldPressed: Bool = true
    public var background: IView? {
        didSet {
            guard self.background !== oldValue else { return }
            self._layout.background = self.background
        }
    }
    public var content: IView? {
        didSet {
            guard self.content !== oldValue else { return }
            self._layout.content = self.content
        }
    }
    public private(set) var leading: IView? {
        didSet {
            guard self.leading !== oldValue else { return }
            self._layout.leading = self.leading
        }
    }
    public var leadingSize: Double {
        set { self._layout.leadingSize = newValue }
        get { self._layout.leadingSize }
    }
    public var isShowedLeading: Bool {
        switch self._layout.state {
        case .leading: return true
        default: return false
        }
    }
    public var leadingLimit: Double = 0
    public var trailing: IView? {
        didSet {
            guard self.trailing !== oldValue else { return }
            self._layout.trailing = self.trailing
        }
    }
    public var trailingSize: Double {
        set { self._layout.trailingSize = newValue }
        get { self._layout.trailingSize }
    }
    public var isShowedTrailing: Bool {
        switch self._layout.state {
        case .trailing: return true
        default: return false
        }
    }
    public var trailingLimit: Double = 0
    public var isSelected: Bool {
        set {
            guard self._isSelected != newValue else { return }
            self._isSelected = newValue
            self.triggeredChangeStyle(false)
        }
        get { self._isSelected }
    }
    public var animationVelocity: Double
#if os(iOS)
    public let pressedGesture = TapGesture()
    public let interactiveGesture = PanGesture()
#endif
    public let onLeading = Signal< Void, Bool >()
    public let onTrailing = Signal< Void, Bool >()
    public let onPressed = Signal< Void, Void >()
    
    private var _isSelected: Bool = false
#if os(iOS)
    private var _interactiveBeginLocation: Point?
    private var _interactiveBeginState: Layout.State?
#endif
    private var _layout: Layout
    private var _animation: ICancellable? {
        willSet { self._animation?.cancel() }
    }
    
    public init() {
#if os(macOS)
        self.animationVelocity = Double(NSScreen.main!.frame.width * 2)
#elseif os(iOS)
        self.animationVelocity = Double(UIScreen.main.bounds.width * 2)
#endif
        self._layout = Layout()
        self.body = CustomView()
            .content(self._layout)
            .shouldHighlighting(true)
#if os(iOS)
            .gestures([ self.pressedGesture, self.interactiveGesture ])
#endif
        self._setup()
    }
    
    deinit {
        self._destroy()
    }
    
}

public extension SwipeCellView {
    
    func showLeading(animated: Bool, completion: (() -> Void)? = nil) {
        switch self._layout.state {
        case .idle:
            if animated == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._layout.state = .leading(progress: .one)
                            self.onLeading.emit(true)
                            completion?()
                        }
                    )
                )
            } else {
                self._layout.state = .leading(progress: .one)
                self.onLeading.emit(true)
                completion?()
            }
        case .leading:
            self.onLeading.emit(true)
            completion?()
            break
        case .trailing:
            self.hideTrailing(animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self.showLeading(animated: animated, completion: completion)
            })
        }
    }
    
    func hideLeading(animated: Bool, completion: (() -> Void)? = nil) {
        switch self._layout.state {
        case .leading:
            if animated == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._layout.state = .idle
                            self.onLeading.emit(false)
                            completion?()
                        }
                    )
                )
            } else {
                self._layout.state = .idle
                self.onLeading.emit(false)
                completion?()
            }
        default:
            completion?()
            self.onLeading.emit(false)
            break
        }
    }
    
    func showTrailing(animated: Bool, completion: (() -> Void)? = nil) {
        switch self._layout.state {
        case .idle:
            if animated == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._layout.state = .trailing(progress: .one)
                            self.onTrailing.emit(true)
                            completion?()
                        }
                    )
                )
            } else {
                self._layout.state = .trailing(progress: .one)
                self.onTrailing.emit(true)
                completion?()
            }
        case .leading:
            self.hideLeading(animated: animated, completion: { [weak self] in
                guard let self = self else { return }
                self.showTrailing(animated: animated, completion: completion)
            })
        case .trailing:
            completion?()
            self.onTrailing.emit(true)
            break
        }
    }
    
    func hideTrailing(animated: Bool, completion: (() -> Void)? = nil) {
        switch self._layout.state {
        case .trailing:
            if animated == true {
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._layout.state = .idle
                            self.onTrailing.emit(false)
                            completion?()
                        }
                    )
                )
            } else {
                self._layout.state = .idle
                self.onTrailing.emit(false)
                completion?()
            }
        default:
            completion?()
            self.onTrailing.emit(false)
            break
        }
    }
    
}

public extension SwipeCellView {
    
    @inlinable
    @discardableResult
    func background(_ value: IView) -> Self {
        self.background = value
        return self
    }
    
    @inlinable
    @discardableResult
    func background(_ value: () -> IView) -> Self {
        return self.background(value())
    }

    @inlinable
    @discardableResult
    func background(_ value: (Self) -> IView) -> Self {
        return self.background(value(self))
    }
    
    @discardableResult
    func content(_ value: IView) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IView) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IView) -> Self {
        return self.content(value(self))
    }
    
    @discardableResult
    func leading(_ value: IView?) -> Self {
        self.leading = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leading(_ value: () -> IView?) -> Self {
        return self.leading(value())
    }

    @inlinable
    @discardableResult
    func leading(_ value: (Self) -> IView?) -> Self {
        return self.leading(value(self))
    }
    
    @discardableResult
    func trailing(_ value: IView?) -> Self {
        self.trailing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: () -> IView?) -> Self {
        return self.trailing(value())
    }

    @inlinable
    @discardableResult
    func trailing(_ value: (Self) -> IView?) -> Self {
        return self.trailing(value(self))
    }
    
    @inlinable
    @discardableResult
    func leadingSize(_ value: Double) -> Self {
        self.leadingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingSize(_ value: () -> Double) -> Self {
        return self.leadingSize(value())
    }

    @inlinable
    @discardableResult
    func leadingSize(_ value: (Self) -> Double) -> Self {
        return self.leadingSize(value(self))
    }
    
    @inlinable
    @discardableResult
    func leadingLimit(_ value: Double) -> Self {
        self.leadingLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingLimit(_ value: () -> Double) -> Self {
        return self.leadingLimit(value())
    }

    @inlinable
    @discardableResult
    func leadingLimit(_ value: (Self) -> Double) -> Self {
        return self.leadingLimit(value(self))
    }
    
    @inlinable
    @discardableResult
    func trailingSize(_ value: Double) -> Self {
        self.trailingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingSize(_ value: () -> Double) -> Self {
        return self.trailingSize(value())
    }

    @inlinable
    @discardableResult
    func trailingSize(_ value: (Self) -> Double) -> Self {
        return self.trailingSize(value(self))
    }
    
    @inlinable
    @discardableResult
    func trailingLimit(_ value: Double) -> Self {
        self.trailingLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingLimit(_ value: () -> Double) -> Self {
        return self.trailingLimit(value())
    }

    @inlinable
    @discardableResult
    func trailingLimit(_ value: (Self) -> Double) -> Self {
        return self.trailingLimit(value(self))
    }
    
    @inlinable
    @discardableResult
    func animationVelocity(_ value: Double) -> Self {
        self.animationVelocity = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animationVelocity(_ value: () -> Double) -> Self {
        return self.animationVelocity(value())
    }

    @inlinable
    @discardableResult
    func animationVelocity(_ value: (Self) -> Double) -> Self {
        return self.animationVelocity(value(self))
    }
    
}

public extension SwipeCellView {
    
    @inlinable
    @discardableResult
    func onLeading(_ closure: @escaping (Bool) -> Void) -> Self {
        self.onLeading.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onLeading(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onLeading.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onLeading< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onLeading.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTrailing(_ closure: @escaping (Bool) -> Void) -> Self {
        self.onTrailing.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTrailing(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onTrailing.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTrailing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onTrailing.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping () -> Void) -> Self {
        self.onPressed.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressed.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressed.add(sender, closure)
        return self
    }
    
}

private extension SwipeCellView {
    
    func _setup() {
#if os(iOS)
        self.pressedGesture
            .onShouldBegin(self, { $0.shouldPressed })
            .onTriggered(self, {
                switch $0._layout.state {
                case .idle: $0.onPressed.emit()
                case .leading: $0.hideLeading(animated: true, completion: nil)
                case .trailing: $0.hideTrailing(animated: true, completion: nil)
                }
            })
        self.interactiveGesture
            .onShouldBegin(self, {
                guard let content = $0.content else { return false }
                guard $0.leading != nil || $0.trailing != nil else { return false }
                let translation = $0.interactiveGesture.translation(in: content)
                guard abs(translation.x) >= abs(translation.y) else { return false }
                return true
            })
            .onBegin(self, { $0._beginInteractiveGesture() })
            .onChange(self, { $0._changeInteractiveGesture() })
            .onCancel(self, { $0._endInteractiveGesture(true) })
            .onEnd(self, { $0._endInteractiveGesture(false) })
#endif
    }
    
    func _destroy() {
        self._animation = nil
    }
    
#if os(iOS)
    
    func _beginInteractiveGesture() {
        self._interactiveBeginLocation = self.interactiveGesture.location(in: self)
        self._interactiveBeginState = self._layout.state
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let beginState = self._interactiveBeginState else { return }
        let currentLocation = self.interactiveGesture.location(in: self)
        let deltaLocation = currentLocation - beginLocation
        switch beginState {
        case .idle:
            if deltaLocation.x > 0 && self.leading != nil {
                let delta = min(deltaLocation.x, self.leadingSize)
                let progress = Percent(delta, from: self.leadingSize)
                self._layout.state = .leading(progress: progress)
            } else if deltaLocation.x < 0 && self.trailing != nil {
                let delta = min(-deltaLocation.x, self.trailingSize)
                let progress = Percent(delta, from: self.trailingSize)
                self._layout.state = .trailing(progress: progress)
            } else {
                self._layout.state = beginState
            }
        case .leading:
            if deltaLocation.x < 0 {
                let delta = min(-deltaLocation.x, self.leadingSize)
                let progress = Percent(delta, from: self.leadingSize)
                self._layout.state = .leading(progress: progress.invert)
            } else {
                self._layout.state = beginState
            }
        case .trailing:
            if deltaLocation.x > 0 {
                let delta = min(deltaLocation.x, self.trailingSize)
                let progress = Percent(delta, from: self.trailingSize)
                self._layout.state = .trailing(progress: progress.invert)
            } else {
                self._layout.state = beginState
            }
        }
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let beginState = self._interactiveBeginState else { return }
        let currentLocation = self.interactiveGesture.location(in: self)
        let deltaLocation = currentLocation - beginLocation
        switch beginState {
        case .idle:
            if deltaLocation.x > 0 && self.leading != nil {
                let delta = min(deltaLocation.x, self.leadingSize)
                if delta >= self.leadingLimit && canceled == false {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.leadingSize / self.animationVelocity),
                            elapsed: TimeInterval(delta / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .leading(progress: progress)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .leading(progress: .one)
                                self.onLeading.emit(true)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.leadingSize / self.animationVelocity),
                            elapsed: TimeInterval((self.leadingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .leading(progress: progress.invert)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .idle
                            }
                        )
                    )
                }
            } else if deltaLocation.x < 0 && self.trailing != nil {
                let delta = min(-deltaLocation.x, self.trailingSize)
                if delta >= self.trailingLimit && canceled == false {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.trailingSize / self.animationVelocity),
                            elapsed: TimeInterval(delta / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .trailing(progress: progress)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .trailing(progress: .one)
                                self.onTrailing.emit(true)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.trailingSize / self.animationVelocity),
                            elapsed: TimeInterval((self.trailingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .trailing(progress: progress.invert)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .idle
                            }
                        )
                    )
                }
            } else {
                self._layout.state = beginState
                self._resetInteractiveAnimation()
            }
        case .leading:
            if deltaLocation.x < 0 {
                let delta = min(-deltaLocation.x, self.leadingSize)
                if delta >= self.leadingLimit && canceled == false {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.leadingSize / self.animationVelocity),
                            elapsed: TimeInterval(delta / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .leading(progress: progress.invert)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .idle
                                self.onLeading.emit(false)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.leadingSize / self.animationVelocity),
                            elapsed: TimeInterval((self.leadingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .leading(progress: progress)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .leading(progress: .one)
                            }
                        )
                    )
                }
            } else {
                self._layout.state = beginState
                self._resetInteractiveAnimation()
            }
        case .trailing:
            if deltaLocation.x > 0 && self.trailing != nil {
                let delta = min(deltaLocation.x, self.trailingSize)
                if delta >= self.trailingLimit && canceled == false {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.trailingSize / self.animationVelocity),
                            elapsed: TimeInterval(delta / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .trailing(progress: progress.invert)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .idle
                                self.onTrailing.emit(false)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self.trailingSize / self.animationVelocity),
                            elapsed: TimeInterval((self.trailingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .trailing(progress: progress)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .trailing(progress: .one)
                            }
                        )
                    )
                }
            } else {
                self._layout.state = beginState
                self._resetInteractiveAnimation()
            }
        }
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginState = nil
        self._interactiveBeginLocation = nil
        self._animation = nil
    }
    
#endif
    
}

extension SwipeCellView : IViewReusable {
}

#if os(iOS)

extension SwipeCellView : IViewTransformable {
}

#endif

extension SwipeCellView : IViewDynamicSizeable {
}

extension SwipeCellView : IViewHighlightable {
}

extension SwipeCellView : IViewSelectable {
}

extension SwipeCellView : IViewLockable {
}

extension SwipeCellView : IViewPressable {
}
