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

    final class SwipeCell : IUIWidgetView, IUIViewHighlightable, IUIViewSelectable, IUIViewLockable, IUIViewPressable, IUIViewColorable, IUIViewBorderable, IUIViewCornerRadiusable, IUIViewShadowable, IUIViewAlphable {
        
        public var isSelected: Bool {
            set(value) {
                if self._isSelected != value {
                    self._isSelected = value
                    self.triggeredChangeStyle(false)
                }
            }
            get { return self._isSelected }
        }
        public var shouldPressed: Bool = true
        public var content: IUIView {
            didSet(oldValue) {
                guard self.content !== oldValue else { return }
                self._layout.content = UI.Layout.Item(self.content)
            }
        }
        public var isShowedLeading: Bool {
            switch self._layout.state {
            case .leading: return true
            default: return false
            }
        }
        public private(set) var leading: IUIView? {
            didSet(oldValue) {
                guard self.leading !== oldValue else { return }
                if let view = self.leading {
                    self._layout.leading = UI.Layout.Item(view)
                } else {
                    self._layout.leading = nil
                }
            }
        }
        public var leadingSize: Float {
            set(value) { self._layout.leadingSize = value }
            get { return self._layout.leadingSize }
        }
        public var leadingLimit: Float = 0
        public var isShowedTrailing: Bool {
            switch self._layout.state {
            case .trailing: return true
            default: return false
            }
        }
        public var trailing: IUIView? {
            didSet(oldValue) {
                guard self.trailing !== oldValue else { return }
                if let view = self.trailing {
                    self._layout.trailing = UI.Layout.Item(view)
                } else {
                    self._layout.trailing = nil
                }
            }
        }
        public var trailingSize: Float {
            set(value) { self._layout.trailingSize = value }
            get { return self._layout.trailingSize }
        }
        public var trailingLimit: Float = 0
        public var animationVelocity: Float
        public private(set) var body: UI.View.Custom
        
        private var _isSelected: Bool = false
        #if os(iOS)
        private var _pressedGesture = UI.Gesture.Tap()
        private var _interactiveGesture = UI.Gesture.Pan()
        private var _interactiveBeginLocation: PointFloat?
        private var _interactiveBeginState: Layout.State?
        #endif
        private var _layout: Layout
        private var _onShowLeading: ((UI.View.SwipeCell) -> Void)?
        private var _onHideLeading: ((UI.View.SwipeCell) -> Void)?
        private var _onShowTrailing: ((UI.View.SwipeCell) -> Void)?
        private var _onHideTrailing: ((UI.View.SwipeCell) -> Void)?
        private var _onPressed: ((UI.View.SwipeCell) -> Void)?
        
        public init(
            _ content: IUIView
        ) {
            self.content = content
            #if os(macOS)
            self.animationVelocity = Float(NSScreen.main!.frame.width * 2)
            #elseif os(iOS)
            self.animationVelocity = Float(UIScreen.main.bounds.width * 2)
            #endif
            self._layout = Layout(content)
            self.body = UI.View.Custom(self._layout)
            #if os(iOS)
                .gestures([ self._pressedGesture, self._interactiveGesture ])
                .shouldHighlighting(true)
            #endif
            self._init()
        }
        
        public convenience init(
            content: IUIView,
            configure: (UI.View.SwipeCell) -> Void
        ) {
            self.init(content)
            self.modify(configure)
        }
        
        public convenience init(customView: IUILayout) {
            self.init(UI.View.Custom(customView))
        }
        
        public func showLeading(animated: Bool, completion: (() -> Void)? = nil) {
            switch self._layout.state {
            case .idle:
                if animated == true {
                    Animation.default.run(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: .one)
                            self._onShowLeading?(self)
                            completion?()
                        }
                    )
                } else {
                    self._layout.state = .leading(progress: .one)
                    self._onShowLeading?(self)
                    completion?()
                }
            case .leading:
                self._onShowLeading?(self)
                completion?()
                break
            case .trailing:
                self.hideTrailing(animated: animated, completion: { [weak self] in
                    self?.showLeading(animated: animated, completion: completion)
                })
            }
        }
        
        public func hideLeading(animated: Bool, completion: (() -> Void)? = nil) {
            switch self._layout.state {
            case .leading:
                if animated == true {
                    Animation.default.run(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .idle
                            self._onHideLeading?(self)
                            completion?()
                        }
                    )
                } else {
                    self._layout.state = .idle
                    self._onHideLeading?(self)
                    completion?()
                }
            default:
                completion?()
                self._onHideLeading?(self)
                break
            }
        }
        
        public func showTrailing(animated: Bool, completion: (() -> Void)? = nil) {
            switch self._layout.state {
            case .idle:
                if animated == true {
                    Animation.default.run(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: .one)
                            self._onShowTrailing?(self)
                            completion?()
                        }
                    )
                } else {
                    self._layout.state = .trailing(progress: .one)
                    self._onShowTrailing?(self)
                    completion?()
                }
            case .leading:
                self.hideLeading(animated: animated, completion: { [weak self] in
                    self?.showTrailing(animated: animated, completion: completion)
                })
            case .trailing:
                completion?()
                self._onShowTrailing?(self)
                break
            }
        }
        
        public func hideTrailing(animated: Bool, completion: (() -> Void)? = nil) {
            switch self._layout.state {
            case .trailing:
                if animated == true {
                    Animation.default.run(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: Animation.Ease.QuadraticInOut(),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .idle
                            self._onHideTrailing?(self)
                            completion?()
                        }
                    )
                } else {
                    self._layout.state = .idle
                    self._onHideTrailing?(self)
                    completion?()
                }
            default:
                completion?()
                self._onHideTrailing?(self)
                break
            }
        }
        
        @discardableResult
        public func content(_ value: IUIView) -> Self {
            self.content = value
            return self
        }
        
        @discardableResult
        public func leading(_ value: IUIView?) -> Self {
            self.leading = value
            return self
        }
        
        @discardableResult
        public func trailing(_ value: IUIView?) -> Self {
            self.trailing = value
            return self
        }
        
        @discardableResult
        public func onShowLeading(_ value: ((UI.View.SwipeCell) -> Void)?) -> Self {
            self._onShowLeading = value
            return self
        }
        
        @discardableResult
        public func onHideLeading(_ value: ((UI.View.SwipeCell) -> Void)?) -> Self {
            self._onHideLeading = value
            return self
        }
        
        @discardableResult
        public func onShowTrailing(_ value: ((UI.View.SwipeCell) -> Void)?) -> Self {
            self._onShowTrailing = value
            return self
        }
        
        @discardableResult
        public func onHideTrailing(_ value: ((UI.View.SwipeCell) -> Void)?) -> Self {
            self._onHideTrailing = value
            return self
        }
        
        @discardableResult
        public func onPressed(_ value: ((UI.View.SwipeCell) -> Void)?) -> Self {
            self._onPressed = value
            return self
        }
        
    }
    
}

public extension UI.View.SwipeCell {
    
    @inlinable
    @discardableResult
    func leadingSize(_ value: Float) -> Self {
        self.leadingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func leadingLimit(_ value: Float) -> Self {
        self.leadingLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingSize(_ value: Float) -> Self {
        self.trailingSize = value
        return self
    }
    
    @inlinable
    @discardableResult
    func trailingLimit(_ value: Float) -> Self {
        self.trailingLimit = value
        return self
    }
    
    @inlinable
    @discardableResult
    func animationVelocity(_ value: Float) -> Self {
        self.animationVelocity = value
        return self
    }
    
}

private extension UI.View.SwipeCell {
    
    func _init() {
        #if os(iOS)
        self._pressedGesture.onShouldBegin({ [unowned self] _ in
            return self.shouldPressed
        }).onTriggered({ [unowned self] _ in
            self._pressed()
        })
        self._interactiveGesture.onShouldBegin({ [unowned self] _ in
            guard self.leading != nil || self.trailing != nil else { return false }
            let translation = self._interactiveGesture.translation(in: self.content)
            guard abs(translation.x) >= abs(translation.y) else { return false }
            return true
        }).onBegin({ [unowned self] _ in
            self._beginInteractiveGesture()
        }).onChange({ [unowned self] _ in
            self._changeInteractiveGesture()
        }).onCancel({ [unowned self] _ in
            self._endInteractiveGesture(true)
        }).onEnd({ [unowned self] _ in
            self._endInteractiveGesture(false)
        })
        #endif
    }
    
    #if os(iOS)
    
    func _pressed() {
        switch self._layout.state {
        case .idle: self._onPressed?(self)
        case .leading: self.hideLeading(animated: true, completion: nil)
        case .trailing: self.hideTrailing(animated: true, completion: nil)
        }
    }
    
    func _beginInteractiveGesture() {
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self)
        self._interactiveBeginState = self._layout.state
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let beginState = self._interactiveBeginState else { return }
        let currentLocation = self._interactiveGesture.location(in: self)
        let deltaLocation = currentLocation - beginLocation
        switch beginState {
        case .idle:
            if deltaLocation.x > 0 && self.leading != nil {
                let delta = min(deltaLocation.x, self.leadingSize)
                let progress = Percent(delta / self.leadingSize)
                self._layout.state = .leading(progress: progress)
            } else if deltaLocation.x < 0 && self.trailing != nil {
                let delta = min(-deltaLocation.x, self.trailingSize)
                let progress = Percent(delta / self.trailingSize)
                self._layout.state = .trailing(progress: progress)
            } else {
                self._layout.state = beginState
            }
        case .leading:
            if deltaLocation.x < 0 {
                let delta = min(-deltaLocation.x, self.leadingSize)
                let progress = Percent(delta / self.leadingSize)
                self._layout.state = .leading(progress: progress.invert)
            } else {
                self._layout.state = beginState
            }
        case .trailing:
            if deltaLocation.x > 0 {
                let delta = min(deltaLocation.x, self.trailingSize)
                let progress = Percent(delta / self.trailingSize)
                self._layout.state = .trailing(progress: progress.invert)
            } else {
                self._layout.state = beginState
            }
        }
    }

    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let beginState = self._interactiveBeginState else { return }
        let currentLocation = self._interactiveGesture.location(in: self)
        let deltaLocation = currentLocation - beginLocation
        switch beginState {
        case .idle:
            if deltaLocation.x > 0 && self.leading != nil {
                let delta = min(deltaLocation.x, self.leadingSize)
                if delta >= self.leadingLimit && canceled == false {
                    Animation.default.run(
                        duration: TimeInterval(self.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: .one)
                            self._resetInteractiveAnimation()
                            self._onShowLeading?(self)
                        }
                    )
                } else {
                    Animation.default.run(
                        duration: TimeInterval(self.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval((self.leadingSize - delta) / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .idle
                            self._resetInteractiveAnimation()
                        }
                    )
                }
            } else if deltaLocation.x < 0 && self.trailing != nil {
                let delta = min(-deltaLocation.x, self.trailingSize)
                if delta >= self.trailingLimit && canceled == false {
                    Animation.default.run(
                        duration: TimeInterval(self.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: .one)
                            self._resetInteractiveAnimation()
                            self._onShowTrailing?(self)
                        }
                    )
                } else {
                    Animation.default.run(
                        duration: TimeInterval(self.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval((self.trailingSize - delta) / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .idle
                            self._resetInteractiveAnimation()
                        }
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
                    Animation.default.run(
                        duration: TimeInterval(self.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .idle
                            self._resetInteractiveAnimation()
                            self._onHideLeading?(self)
                        }
                    )
                } else {
                    Animation.default.run(
                        duration: TimeInterval(self.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval((self.leadingSize - delta) / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: .one)
                            self._resetInteractiveAnimation()
                        }
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
                    Animation.default.run(
                        duration: TimeInterval(self.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .idle
                            self._resetInteractiveAnimation()
                            self._onHideTrailing?(self)
                        }
                    )
                } else {
                    Animation.default.run(
                        duration: TimeInterval(self.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval((self.trailingSize - delta) / self.animationVelocity),
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: .one)
                            self._resetInteractiveAnimation()
                        }
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
    }
    
    #endif
    
}
