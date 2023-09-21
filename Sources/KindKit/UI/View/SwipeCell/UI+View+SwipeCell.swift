//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension UI.View {
    
    final class SwipeCell : IUIWidgetView {
        
        public let body: UI.View.Custom
        public var shouldPressed: Bool = true
        public var background: IUIView? {
            didSet {
                guard self.background !== oldValue else { return }
                self._layout.background = self.background
            }
        }
        public var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = self.content
            }
        }
        public private(set) var leading: IUIView? {
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
        public var trailing: IUIView? {
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
        public let pressedGesture = UI.Gesture.Tap()
        public let interactiveGesture = UI.Gesture.Pan()
#endif
        public let onLeading: Signal.Args< Void, Bool > = .init()
        public let onTrailing: Signal.Args< Void, Bool > = .init()
        public let onPressed: Signal.Empty< Void > = .init()
        
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
            self.body = UI.View.Custom()
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
    
}

public extension UI.View.SwipeCell {
    
    func showLeading(animated: Bool, completion: (() -> Void)? = nil) {
        switch self._layout.state {
        case .idle:
            if animated == true {
                self._animation = Animation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                self._animation = Animation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                self._animation = Animation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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
                self._animation = Animation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
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

public extension UI.View.SwipeCell {
    
    @discardableResult
    func content(_ value: IUIView) -> Self {
        self.content = value
        return self
    }
    
    @inlinable
    @discardableResult
    func content(_ value: () -> IUIView) -> Self {
        return self.content(value())
    }

    @inlinable
    @discardableResult
    func content(_ value: (Self) -> IUIView) -> Self {
        return self.content(value(self))
    }
    
    @discardableResult
    func leading(_ value: IUIView?) -> Self {
        self.leading = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leading(_ value: () -> IUIView?) -> Self {
        return self.leading(value())
    }

    @inlinable
    @discardableResult
    func leading(_ value: (Self) -> IUIView?) -> Self {
        return self.leading(value(self))
    }
    
    @discardableResult
    func trailing(_ value: IUIView?) -> Self {
        self.trailing = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailing(_ value: () -> IUIView?) -> Self {
        return self.trailing(value())
    }

    @inlinable
    @discardableResult
    func trailing(_ value: (Self) -> IUIView?) -> Self {
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

public extension UI.View.SwipeCell {
    
    @inlinable
    @discardableResult
    func onLeading(_ closure: ((Bool) -> Void)?) -> Self {
        self.onLeading.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onLeading(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onLeading.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onLeading< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onLeading.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTrailing(_ closure: ((Bool) -> Void)?) -> Self {
        self.onTrailing.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTrailing(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onTrailing.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onTrailing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onTrailing.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: (() -> Void)?) -> Self {
        self.onPressed.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressed.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressed.link(sender, closure)
        return self
    }
    
}

private extension UI.View.SwipeCell {
    
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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
                    self._animation = Animation.default.run(
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

extension UI.View.SwipeCell : IUIViewReusable {
}

#if os(iOS)

extension UI.View.SwipeCell : IUIViewTransformable {
}

#endif

extension UI.View.SwipeCell : IUIViewDynamicSizeable {
}

extension UI.View.SwipeCell : IUIViewHighlightable {
}

extension UI.View.SwipeCell : IUIViewSelectable {
}

extension UI.View.SwipeCell : IUIViewLockable {
}

extension UI.View.SwipeCell : IUIViewPressable {
}

public extension IUIView where Self == UI.View.SwipeCell {
    
    @inlinable
    static func swipeCell(_ content: IUIView) -> Self {
        return .init().content(content)
    }
    
}
