//
//  KindKit
//

import KindAnimation
import KindUI

public extension Container {
    
    final class Hamburger : IHamburgerContainer {
        
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
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                self._leading?.didChange(orientation: self.orientation)
                self._content.didChange(orientation: self.orientation)
                self._trailing?.didChange(orientation: self.orientation)
            }
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IView {
            return self._view
        }
        public var content: IHamburgerContentContainer {
            set {
                guard self._content !== newValue else { return }
                if self.isPresented == true {
                    self._content.prepareHide(interactive: false)
                    self._content.finishHide(interactive: false)
                    self._content.refreshParentInset()
                }
                self._content.parent = nil
                self._content = newValue
                self._content.parent = self
                self._layout.content = self._content.view
                if self.isPresented == true {
                    self._content.refreshParentInset()
                    self._content.prepareShow(interactive: false)
                    self._content.finishShow(interactive: false)
                }
            }
            get { self._content }
        }
        public var leading: IHamburgerMenuContainer? {
            set {
                guard self._leading !== newValue else { return }
                if let leading = self._leading {
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .leading:
                            leading.prepareHide(interactive: false)
                            leading.finishHide(interactive: false)
                            leading.refreshParentInset()
                        default:
                            break
                        }
                    }
                    leading.parent = nil
                }
                self._leading = newValue
                if let leading = self._leading {
                    leading.parent = self
                    self._layout.leading = leading.view
                    self._layout.leadingSize = leading.hamburgerSize
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .leading:
                            leading.refreshParentInset()
                            leading.prepareShow(interactive: false)
                            leading.finishShow(interactive: false)
                        default:
                            break
                        }
                    }
                }
            }
            get { self._leading }
        }
        public var isShowedLeading: Bool {
            switch self._layout.state {
            case .leading: return true
            default: return false
            }
        }
        public var trailing: IHamburgerMenuContainer? {
            set {
                guard self._trailing !== newValue else { return }
                if let trailing = self._trailing {
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .trailing:
                            trailing.prepareHide(interactive: false)
                            trailing.finishHide(interactive: false)
                            trailing.refreshParentInset()
                        default:
                            break
                        }
                    }
                    trailing.parent = nil
                }
                self._trailing = newValue
                if let trailing = self._trailing {
                    trailing.parent = self
                    self._layout.trailing = trailing.view
                    self._layout.trailingSize = trailing.hamburgerSize
                    if self.isPresented == true {
                        switch self._layout.state {
                        case .trailing:
                            trailing.refreshParentInset()
                            trailing.prepareShow(interactive: false)
                            trailing.finishShow(interactive: false)
                        default:
                            break
                        }
                    }
                }
            }
            get { self._trailing }
        }
        public var isShowedTrailing: Bool {
            switch self._layout.state {
            case .trailing: return true
            default: return false
            }
        }
        public var animationVelocity: Double
        
        private var _layout: Layout
        private var _view: CustomView
#if os(iOS)
        private var _pressedGesture = TapGesture()
        private var _interactiveGesture = PanGesture()
        private var _interactiveBeginLocation: Point?
        private var _interactiveBeginState: Layout.State?
        private var _interactiveLeading: IHamburgerMenuContainer?
        private var _interactiveTrailing: IHamburgerMenuContainer?
#endif
        private var _content: IHamburgerContentContainer
        private var _leading: IHamburgerMenuContainer?
        private var _trailing: IHamburgerMenuContainer?
        private var _animation: ICancellable? {
            willSet { self._animation?.cancel() }
        }
        
        public init(
            content: IHamburgerContentContainer,
            leading: IHamburgerMenuContainer? = nil,
            trailing: IHamburgerMenuContainer? = nil
        ) {
            self.isPresented = false
#if os(macOS)
            self.animationVelocity = NSScreen.kk_animationVelocity
#elseif os(iOS)
            self.animationVelocity = UIScreen.kk_animationVelocity
#endif
            self._content = content
            self._leading = leading
            self._trailing = trailing
            self._layout = .init(
                content: content.view,
                leading: leading?.view,
                leadingSize: leading?.hamburgerSize ?? 0,
                trailing: trailing?.view,
                trailingSize: trailing?.hamburgerSize ?? 0
            )
            self._view = CustomView()
                .content(self._layout)
#if os(iOS)
                .gestures([ self._pressedGesture, self._interactiveGesture ])
#endif
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
            self._content.apply(contentInset: contentInset)
            if let container = self._leading {
                container.apply(contentInset: contentInset)
            }
            if let container = self._trailing {
                container.apply(contentInset: contentInset)
            }
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> Container.AccumulateInset {
            let contentInset = self._content.contentInset()
            switch self._layout.state {
            case .idle:
                return contentInset
            case .leading(let progress):
                guard let leading = self._leading else { return contentInset }
                let leadingInset = leading.contentInset()
                return contentInset.lerp(leadingInset, progress: progress)
            case .trailing(let progress):
                guard let trailing = self._trailing else { return contentInset }
                let trailingInset = trailing.contentInset()
                return contentInset.lerp(trailingInset, progress: progress)
            }
        }
        
        public func refreshParentInset() {
            self._leading?.refreshParentInset()
            self._content.refreshParentInset()
            self._trailing?.refreshParentInset()
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
                self.hideLeading(
                    animated: true,
                    completion: nil
                )
                return true
            case .trailing:
                if let container = self._trailing {
                    if container.activate() == true {
                        return true
                    }
                }
                self.hideTrailing(
                    animated: true,
                    completion: nil
                )
                return true
            }
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            switch self._layout.state {
            case .idle:
                return self._content.snake()
            case .leading:
                if let container = self._leading {
                    if container.snake() == true {
                        return true
                    }
                }
            case .trailing:
                if let container = self._trailing {
                    if container.snake() == true {
                        return true
                    }
                }
            }
            return false
        }
        
#endif
        
        public func didChangeAppearance() {
            self._content.didChangeAppearance()
            if let container = self._leading {
                container.didChangeAppearance()
            }
            if let container = self._trailing {
                container.didChangeAppearance()
            }
        }
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
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
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
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

extension Container.Hamburger : IRootContentContainer {
}

private extension Container.Hamburger {
    
    func _setup() {
#if os(iOS)
        self._pressedGesture
            .onShouldBeRequiredToFailBy(self, {
                guard let view = $1.view else { return false }
                return $0._view.native.kk_isChild(of: view, recursive: true)
            })
            .onShouldBegin(self, {
                switch $0._layout.state {
                case .idle: return false
                case .leading, .trailing: return $0._pressedGesture.contains(in: $0._content.view)
                }
            })
            .onTriggered(self, { $0._pressed() })
        self._interactiveGesture
            .onShouldBegin(self, {
                guard $0._leading != nil || $0._trailing != nil else { return false }
                guard $0._content.shouldInteractive == true else { return false }
                return true
            })
            .onBegin(self, { $0._beginInteractiveGesture() })
            .onChange(self, { $0._changeInteractiveGesture() })
            .onCancel(self, { $0._endInteractiveGesture(true) })
            .onEnd(self, { $0._endInteractiveGesture(false) })
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
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        preparing: { [weak self] in
                            guard let self = self else { return }
                            self._view.locked = true
                        },
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._view.locked = false
                            self._layout.state = .leading(progress: .one)
                            leading.finishShow(interactive: interactive)
                            completion?()
                        }
                    )
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
            self._hideTrailing(interactive: interactive, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
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
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        preparing: { [weak self] in
                            guard let self = self else { return }
                            self._view.locked = true
                        },
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .leading(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._view.locked = false
                            self._layout.state = .idle
                            leading.finishHide(interactive: interactive)
                            completion?()
                        }
                    )
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
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        preparing: { [weak self] in
                            guard let self = self else { return }
                            self._view.locked = true
                        },
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._view.locked = false
                            self._layout.state = .trailing(progress: .one)
                            trailing.finishShow(interactive: interactive)
                            completion?()
                        }
                    )
                )
            } else {
                self._layout.state = .trailing(progress: .one)
                trailing.finishShow(interactive: interactive)
                completion?()
            }
        case .leading:
            self._hideLeading(interactive: interactive, animated: animated, completion: { [weak self] in
                guard let self = self else { return }
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
                self._animation = KindAnimation.default.run(
                    .custom(
                        duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                        ease: KindAnimation.Ease.QuadraticInOut(),
                        preparing: { [weak self] in
                            guard let self = self else { return }
                            self._view.locked = true
                        },
                        processing: { [weak self] progress in
                            guard let self = self else { return }
                            self._layout.state = .trailing(progress: progress.invert)
                            self._layout.updateIfNeeded()
                        },
                        completion: { [weak self] in
                            guard let self = self else { return }
                            self._animation = nil
                            self._view.locked = false
                            self._layout.state = .idle
                            trailing.finishHide(interactive: interactive)
                            completion?()
                        }
                    )
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

private extension Container.Hamburger {
    
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
                let progress = Percent(delta, from: self._layout.leadingSize)
                self._layout.state = .leading(progress: progress)
            } else if deltaLocation.x < 0 && self._trailing != nil {
                if self._interactiveTrailing == nil {
                    self._trailing!.prepareShow(interactive: true)
                    self._interactiveTrailing = self._trailing
                }
                let delta = min(-deltaLocation.x, self._layout.trailingSize)
                let progress = Percent(delta, from: self._layout.trailingSize)
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
                let progress = Percent(delta, from: self._layout.leadingSize)
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
                let progress = Percent(delta, from: self._layout.trailingSize)
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
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
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
                                leading.finishShow(interactive: true)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                            elapsed: TimeInterval((self._layout.leadingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .leading(progress: progress.invert)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .idle
                                leading.cancelShow(interactive: true)
                            }
                        )
                    )
                }
            } else if let trailing = self._interactiveTrailing, deltaLocation.x < 0 {
                let delta = min(-deltaLocation.x, self._layout.trailingSize)
                if delta >= trailing.hamburgerLimit && canceled == false {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
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
                                trailing.finishShow(interactive: true)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                            elapsed: TimeInterval((self._layout.trailingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .trailing(progress: progress.invert)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .idle
                                trailing.cancelShow(interactive: true)
                            }
                        )
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
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
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
                                leading.finishHide(interactive: true)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.leadingSize / self.animationVelocity),
                            elapsed: TimeInterval((self._layout.leadingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .leading(progress: progress)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .leading(progress: .one)
                                leading.cancelHide(interactive: true)
                            }
                        )
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
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
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
                                trailing.finishHide(interactive: true)
                            }
                        )
                    )
                } else {
                    self._animation = KindAnimation.default.run(
                        .custom(
                            duration: TimeInterval(self._layout.trailingSize / self.animationVelocity),
                            elapsed: TimeInterval((self._layout.trailingSize - delta) / self.animationVelocity),
                            processing: { [weak self] progress in
                                guard let self = self else { return }
                                self._layout.state = .trailing(progress: progress)
                                self._layout.updateIfNeeded()
                            },
                            completion: { [weak self] in
                                guard let self = self else { return }
                                self._resetInteractiveAnimation()
                                self._layout.state = .trailing(progress: .one)
                                trailing.cancelHide(interactive: true)
                            }
                        )
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
