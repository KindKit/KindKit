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
    
    final class Hamburger : IUIHamburgerContainer {
        
        public unowned var parent: IUIContainer? {
            didSet(oldValue) {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
                }
            }
        }
        public var shouldInteractive: Bool {
            return self._content.shouldInteractive
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return self._content.statusBar
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self._content.statusBarAnimation
        }
        public var statusBarHidden: Bool {
            return self._content.statusBarHidden
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self._content.supportedOrientations
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public var content: IUIHamburgerContentContainer {
            set(value) {
                guard self._content !== value else { return }
                if self.isPresented == true {
                    self._content.prepareHide(interactive: false)
                    self._content.finishHide(interactive: false)
                }
                self._content.parent = nil
                self._content = value
                self._content.parent = self
                self._layout.content = UI.Layout.Item(self._content.view)
                if self.isPresented == true {
                    self._content.prepareShow(interactive: false)
                    self._content.finishShow(interactive: false)
                }
                self.didChangeInsets()
            }
            get { return self._content }
        }
        public var leading: IHamburgerMenuContainer? {
            set(value) {
                guard self._leading !== value else { return }
                if let leading = self._leading {
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .leading:
                            leading.prepareHide(interactive: false)
                            leading.finishHide(interactive: false)
                        default:
                            break
                        }
                    }
                    leading.parent = nil
                }
                self._leading = value
                if let leading = self._leading {
                    leading.parent = self
                    self._layout.leading = UI.Layout.Item(leading.view)
                    self._layout.leadingSize = leading.hamburgerSize
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .leading:
                            leading.prepareShow(interactive: false)
                            leading.finishShow(interactive: false)
                        default:
                            break
                        }
                    }
                }
                self.didChangeInsets()
            }
            get { return self._leading }
        }
        public var isShowedLeading: Bool {
            switch self._layout.state {
            case .leading: return true
            default: return false
            }
        }
        public var trailing: IHamburgerMenuContainer? {
            set(value) {
                guard self._trailing !== value else { return }
                if let trailing = self._trailing {
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .trailing:
                            trailing.prepareHide(interactive: false)
                            trailing.finishHide(interactive: false)
                        default:
                            break
                        }
                    }
                    trailing.parent = nil
                }
                self._trailing = value
                if let trailing = self._trailing {
                    trailing.parent = self
                    self._layout.trailing = UI.Layout.Item(trailing.view)
                    self._layout.trailingSize = trailing.hamburgerSize
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .trailing:
                            trailing.prepareShow(interactive: false)
                            trailing.finishShow(interactive: false)
                        default:
                            break
                        }
                    }
                }
                self.didChangeInsets()
            }
            get { return self._trailing }
        }
        public var isShowedTrailing: Bool {
            switch self._layout.state {
            case .trailing: return true
            default: return false
            }
        }
        public var animationVelocity: Float
        
        private var _layout: Layout
        private var _view: UI.View.Custom
#if os(iOS)
        private var _pressedGesture = UI.Gesture.Tap()
        private var _interactiveGesture = UI.Gesture.Pan()
        private var _interactiveBeginLocation: PointFloat?
        private var _interactiveBeginState: Layout.State?
        private var _interactiveLeading: IHamburgerMenuContainer?
        private var _interactiveTrailing: IHamburgerMenuContainer?
#endif
        private var _content: IUIHamburgerContentContainer
        private var _leading: IHamburgerMenuContainer?
        private var _trailing: IHamburgerMenuContainer?
        private var _animation: IAnimationTask? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            content: IUIHamburgerContentContainer,
            leading: IHamburgerMenuContainer? = nil,
            trailing: IHamburgerMenuContainer? = nil
        ) {
            self.isPresented = false
#if os(macOS)
            self.animationVelocity = NSScreen.main!.animationVelocity
#elseif os(iOS)
            self.animationVelocity = UIScreen.main.animationVelocity
#endif
            self._content = content
            self._leading = leading
            self._trailing = trailing
            self._layout = .init(
                content: UI.Layout.Item(content.view),
                leading: leading.flatMap({ UI.Layout.Item($0.view) }),
                leadingSize: leading?.hamburgerSize ?? 0,
                trailing: trailing.flatMap({ UI.Layout.Item($0.view) }),
                trailingSize: trailing?.hamburgerSize ?? 0
            )
            self._view = UI.View.Custom(self._layout)
#if os(iOS)
            self._view.gestures([ self._pressedGesture, self._interactiveGesture ])
#endif
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
            self._leading?.didChangeInsets()
            self._content.didChangeInsets()
            self._trailing?.didChangeInsets()
        }
        
        public func activate() -> Bool {
            switch self._layout.state {
            case .idle:
                return self._content.activate()
            case .leading:
                if let container = self._leading {
                    if container.activate() == true {
                        return true
                    }
                }
                self.hideLeading()
                return true
            case .trailing:
                if let container = self._trailing {
                    if container.activate() == true {
                        return true
                    }
                }
                self.hideTrailing()
                return true
            }
        }
        
        public func didChangeAppearance() {
            self._content.didChangeAppearance()
            if let container = self._leading {
                container.didChangeAppearance()
            }
            if let container = self._trailing {
                container.didChangeAppearance()
            }
        }
        
        public func prepareShow(interactive: Bool) {
            self._content.prepareShow(interactive: interactive)
            switch self._layout.state {
            case .idle: break
            case .leading: self._leading?.prepareShow(interactive: interactive)
            case .trailing: self._trailing?.prepareShow(interactive: interactive)
            }
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self._content.finishShow(interactive: interactive)
            switch self._layout.state {
            case .idle: break
            case .leading: self._leading?.finishShow(interactive: interactive)
            case .trailing: self._trailing?.finishShow(interactive: interactive)
            }
        }
        
        public func cancelShow(interactive: Bool) {
            self._content.cancelShow(interactive: interactive)
            switch self._layout.state {
            case .idle: break
            case .leading: self._leading?.cancelShow(interactive: interactive)
            case .trailing: self._trailing?.cancelShow(interactive: interactive)
            }
        }
        
        public func prepareHide(interactive: Bool) {
            self._content.prepareHide(interactive: interactive)
            switch self._layout.state {
            case .idle: break
            case .leading: self._leading?.prepareHide(interactive: interactive)
            case .trailing: self._trailing?.prepareHide(interactive: interactive)
            }
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self._content.finishHide(interactive: interactive)
            switch self._layout.state {
            case .idle: break
            case .leading: self._leading?.finishHide(interactive: interactive)
            case .trailing: self._trailing?.finishHide(interactive: interactive)
            }
        }
        
        public func cancelHide(interactive: Bool) {
            self._content.cancelHide(interactive: interactive)
            switch self._layout.state {
            case .idle: break
            case .leading: self._leading?.cancelHide(interactive: interactive)
            case .trailing: self._trailing?.cancelHide(interactive: interactive)
            }
        }
        
        public func showLeading(animated: Bool, completion: (() -> Void)?) {
            self._showLeading(interactive: false, animated: animated, completion: completion)
        }
        
        public func hideLeading(animated: Bool, completion: (() -> Void)?) {
            self._hideLeading(interactive: false, animated: animated, completion: completion)
        }
        
        public func showTrailing(animated: Bool, completion: (() -> Void)?) {
            self._showTrailing(interactive: false, animated: animated, completion: completion)
        }
        
        public func hideTrailing(animated: Bool, completion: (() -> Void)?) {
            self._hideTrailing(interactive: false, animated: animated, completion: completion)
        }
        
    }
    
}

extension UI.Container.Hamburger : IUIRootContentContainer {
}

private extension UI.Container.Hamburger {
    
    func _setup() {
#if os(iOS)
        self._pressedGesture.onShouldBeRequiredToFailBy({ [unowned self] _, gesture -> Bool in
            guard let view = gesture.view else { return false }
            return self._view.native.isChild(of: view, recursive: true)
        }).onShouldBegin({ [unowned self] _ in
            switch self._layout.state {
            case .idle: return false
            case .leading, .trailing: return self._pressedGesture.contains(in: self._content.view)
            }
        }).onTriggered({ [unowned self] _ in
            self._pressed()
        })
        self._interactiveGesture.onShouldBegin({ [unowned self] _ in
            guard self._leading != nil || self._trailing != nil else { return false }
            guard self._content.shouldInteractive == true else { return false }
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
        self._content.parent = self
        self._leading?.parent = self
        self._trailing?.parent = self
    }
    
    func _destroy() {
        self._animation = nil
    }
    
    func _showLeading(interactive: Bool, animated: Bool, completion: (() -> Void)?) {
        guard let leading = self._leading else {
            completion?()
            return
        }
        switch self._layout.state {
        case .idle:
            leading.prepareShow(interactive: interactive)
            if animated == true {
                self._animation = Animation.default.run(
                    duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self._layout.state = .leading(progress: progress)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [unowned self] in
                        self._animation = nil
                        self._layout.state = .leading(progress: .one)
                        leading.finishShow(interactive: interactive)
                        completion?()
                    }
                )
            } else {
                self._layout.state = .leading(progress: .one)
                leading.finishShow(interactive: interactive)
                completion?()
            }
        case .leading:
            completion?()
            break
        case .trailing:
            self._hideTrailing(interactive: interactive, animated: animated, completion: { [unowned self] in
                self._showLeading(interactive: interactive, animated: animated, completion: completion)
            })
        }
    }
    
    func _hideLeading(interactive: Bool, animated: Bool, completion: (() -> Void)?) {
        guard let leading = self._leading else {
            completion?()
            return
        }
        switch self._layout.state {
        case .leading:
            leading.prepareHide(interactive: interactive)
            if animated == true {
                self._animation = Animation.default.run(
                    duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self._layout.state = .leading(progress: progress.invert)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [unowned self] in
                        self._animation = nil
                        self._layout.state = .idle
                        leading.finishHide(interactive: interactive)
                        completion?()
                    }
                )
            } else {
                self._layout.state = .idle
                leading.finishHide(interactive: interactive)
                completion?()
            }
        default:
            completion?()
            break
        }
    }
    
    func _showTrailing(interactive: Bool, animated: Bool, completion: (() -> Void)?) {
        guard let trailing = self._trailing else {
            completion?()
            return
        }
        switch self._layout.state {
        case .idle:
            trailing.prepareShow(interactive: interactive)
            if animated == true {
                self._animation = Animation.default.run(
                    duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self._layout.state = .trailing(progress: progress)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [unowned self] in
                        self._animation = nil
                        self._layout.state = .trailing(progress: .one)
                        trailing.finishShow(interactive: interactive)
                        completion?()
                    }
                )
            } else {
                self._layout.state = .trailing(progress: .one)
                trailing.finishShow(interactive: interactive)
                completion?()
            }
        case .leading:
            self._hideLeading(interactive: interactive, animated: animated, completion: { [unowned self] in
                self._showTrailing(interactive: interactive, animated: animated, completion: completion)
            })
        case .trailing:
            completion?()
            break
        }
    }
    
    func _hideTrailing(interactive: Bool, animated: Bool, completion: (() -> Void)?) {
        guard let trailing = self._trailing else {
            completion?()
            return
        }
        switch self._layout.state {
        case .trailing:
            trailing.prepareHide(interactive: interactive)
            if animated == true {
                self._animation = Animation.default.run(
                    duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                    ease: Animation.Ease.QuadraticInOut(),
                    processing: { [unowned self] progress in
                        self._layout.state = .trailing(progress: progress.invert)
                        self._layout.updateIfNeeded()
                    },
                    completion: { [unowned self] in
                        self._animation = nil
                        self._layout.state = .idle
                        trailing.finishHide(interactive: interactive)
                        completion?()
                    }
                )
            } else {
                self._layout.state = .idle
                trailing.finishHide(interactive: interactive)
                completion?()
            }
        default:
            completion?()
            break
        }
    }
    
}

#if os(iOS)

private extension UI.Container.Hamburger {
    
    func _pressed() {
        switch self._layout.state {
        case .idle: break
        case .leading: self._hideLeading(interactive: true, animated: true, completion: nil)
        case .trailing: self._hideTrailing(interactive: true, animated: true, completion: nil)
        }
    }
    
    func _beginInteractiveGesture() {
        self._interactiveBeginLocation = self._interactiveGesture.location(in: self.view)
        self._interactiveBeginState = self._layout.state
    }
    
    func _changeInteractiveGesture() {
        guard let beginLocation = self._interactiveBeginLocation, let beginState = self._interactiveBeginState else { return }
        let currentLocation = self._interactiveGesture.location(in: self.view)
        let deltaLocation = currentLocation - beginLocation
        switch beginState {
        case .idle:
            if deltaLocation.x > 0 && self._leading != nil {
                if self._interactiveLeading == nil {
                    self._leading!.prepareShow(interactive: true)
                    self._interactiveLeading = self._leading
                }
                let delta = min(deltaLocation.x, self._layout.leadingSize)
                let progress = Percent(delta / self._layout.leadingSize)
                self._layout.state = .leading(progress: progress)
            } else if deltaLocation.x < 0 && self._trailing != nil {
                if self._interactiveTrailing == nil {
                    self._trailing!.prepareShow(interactive: true)
                    self._interactiveTrailing = self._trailing
                }
                let delta = min(-deltaLocation.x, self._layout.trailingSize)
                let progress = Percent(delta / self._layout.trailingSize)
                self._layout.state = .trailing(progress: progress)
            } else {
                self._layout.state = beginState
            }
        case .leading:
            if deltaLocation.x < 0 {
                if self._interactiveLeading == nil {
                    self._leading!.prepareHide(interactive: true)
                    self._interactiveLeading = self._leading
                }
                let delta = min(-deltaLocation.x, self._layout.leadingSize)
                let progress = Percent(delta / self._layout.leadingSize)
                self._layout.state = .leading(progress: progress.invert)
            } else {
                self._layout.state = beginState
            }
        case .trailing:
            if deltaLocation.x > 0 {
                if self._interactiveTrailing == nil {
                    self._trailing!.prepareHide(interactive: true)
                    self._interactiveTrailing = self._trailing
                }
                let delta = min(deltaLocation.x, self._layout.trailingSize)
                let progress = Percent(delta / self._layout.trailingSize)
                self._layout.state = .trailing(progress: progress.invert)
            } else {
                self._layout.state = beginState
            }
        }
    }
    
    func _endInteractiveGesture(_ canceled: Bool) {
        guard let beginLocation = self._interactiveBeginLocation, let beginState = self._interactiveBeginState else { return }
        let currentLocation = self._interactiveGesture.location(in: self.view)
        let deltaLocation = currentLocation - beginLocation
        switch beginState {
        case .idle:
            if let leading = self._interactiveLeading, deltaLocation.x > 0 {
                let delta = min(deltaLocation.x, self._layout.leadingSize)
                if delta >= leading.hamburgerLimit && canceled == false {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .leading(progress: .one)
                            leading.finishShow(interactive: true)
                        }
                    )
                } else {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval((self._layout.leadingSize - delta) / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .idle
                            leading.cancelShow(interactive: true)
                        }
                    )
                }
            } else if let trailing = self._interactiveTrailing, deltaLocation.x < 0 {
                let delta = min(-deltaLocation.x, self._layout.trailingSize)
                if delta >= trailing.hamburgerLimit && canceled == false {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .trailing(progress: .one)
                            trailing.finishShow(interactive: true)
                        }
                    )
                } else {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval((self._layout.trailingSize - delta) / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .idle
                            trailing.cancelShow(interactive: true)
                        }
                    )
                }
            } else {
                self._resetInteractiveAnimation()
                self._layout.state = beginState
            }
        case .leading:
            if let leading = self._interactiveLeading, deltaLocation.x < 0 {
                let delta = min(-deltaLocation.x, self._layout.leadingSize)
                if delta >= leading.hamburgerLimit && canceled == false {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .idle
                            leading.finishHide(interactive: true)
                        }
                    )
                } else {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        elapsed: TimeInterval((self._layout.leadingSize - delta) / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .leading(progress: .one)
                            leading.cancelHide(interactive: true)
                        }
                    )
                }
            } else {
                self._resetInteractiveAnimation()
                self._layout.state = beginState
            }
        case .trailing:
            if let trailing = self._interactiveTrailing, deltaLocation.x > 0 {
                let delta = min(deltaLocation.x, self._layout.trailingSize)
                if delta >= trailing.hamburgerLimit && canceled == false {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval(delta / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .idle
                            trailing.finishHide(interactive: true)
                        }
                    )
                } else {
                    self._animation = Animation.default.run(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        elapsed: TimeInterval((self._layout.trailingSize - delta) / self.animationVelocity),
                        processing: { [unowned self] progress in
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [unowned self] in
                            self._resetInteractiveAnimation()
                            self._layout.state = .trailing(progress: .one)
                            trailing.cancelHide(interactive: true)
                        }
                    )
                }
            } else {
                self._resetInteractiveAnimation()
                self._layout.state = beginState
            }
        }
    }
    
    func _resetInteractiveAnimation() {
        self._interactiveBeginState = nil
        self._interactiveBeginLocation = nil
        self._interactiveLeading = nil
        self._interactiveTrailing = nil
        self._animation = nil
    }
    
}

#endif
