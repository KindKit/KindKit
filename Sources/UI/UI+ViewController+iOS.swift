//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI {
    
    final class ViewController : UIViewController {
        
        public let container: UI.Container.Root
        public private(set) var virtualKeyboardHeight: Float {
            didSet(oldValue) {
                guard self.virtualKeyboardHeight != oldValue else { return }
                self._updateSafeArea()
            }
        }
        public override var preferredStatusBarStyle: UIStatusBarStyle {
            return self.container.statusBar
        }
        public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
            return self.container.statusBarAnimation
        }
        public override var prefersStatusBarHidden: Bool {
            return self.container.statusBarHidden
        }
        public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return self.container.supportedOrientations
        }
        public override var shouldAutorotate: Bool {
            return true
        }
        
        private var _containerView: UIView? {
            willSet(newValue) {
                guard self._containerView != newValue else { return }
                if let containerView = self._containerView {
                    containerView.removeFromSuperview()
                }
            }
            didSet(oldValue) {
                guard self._containerView != oldValue else { return }
                if let containerView = self._containerView {
                    containerView.frame = self.view.bounds
                    self.view.addSubview(containerView)
                    containerView.layoutIfNeeded()
                }
            }
        }
        private var _virtualKeyboard: VirtualKeyboard
        private var _virtualKeyboardAnimationTask: IAnimationTask?
        private var _owner: AnyObject?
        
        private init(
            container: UI.Container.Root,
            owner: AnyObject? = nil
        ) {
            self.container = container
            self.virtualKeyboardHeight = 0
            self._virtualKeyboard = VirtualKeyboard()
            self._owner = owner
            
            super.init(nibName: nil, bundle: nil)
            
            self.container.delegate = self
            self._virtualKeyboard.add(observer: self, priority: .public)
            UI.Container.BarController.shared.add(observer: self)
            
            if #available(iOS 13, *) {
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(self._didChangeStatusBarFrame(_:)), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
            }
        }
        
        convenience init(
            _ container: UI.Container.Root
        ) {
            self.init(container: container)
        }
        
        public convenience init(
            _ container: IUIRootContentContainer
        ) {
            self.init(UI.Container.Root(
                content: container
            ))
        }
        
        public convenience init< Screen : IUIScreen & IUIScreenViewable >(
            _ screen: Screen
        ) {
            self.init(UI.Container.Screen(screen))
        }
        
        public convenience init< Wireframe : IUIWireframe >(
            _ wireframe: Wireframe
        ) where Wireframe : AnyObject, Wireframe.Container == UI.Container.Root {
            self.init(
                container: wireframe.container,
                owner: wireframe
            )
        }
        
        public convenience init< Wireframe : IUIWireframe >(
            _ wireframe: Wireframe
        ) where Wireframe : AnyObject, Wireframe.Container : IUIRootContentContainer {
            self.init(
                container: UI.Container.Root(
                    content: wireframe.container
                ),
                owner: wireframe
            )
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            self._free()
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.container.safeArea = self._safeArea()
            if let substrate = self.container.statusBarSubstrate {
                substrate.height = .fixed(self._statusBarHeight())
            }
            self._containerView = self.container.view.native
            if self.container.isPresented == false {
                self.container.prepareShow(interactive: false)
                self.container.finishShow(interactive: false)
            }
        }
        
        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self._updateStatusBarHeight()
        }
        
        public override func viewDidDisappear(_ animated: Bool) {
            self._containerView = nil
            super.viewDidDisappear(animated)
        }
        
        public override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            self._updateSafeArea()
            if let containerView = self._containerView {
                containerView.frame = self.view.bounds
            }
        }
        
        @available(iOS 11.0, *)
        public override func viewSafeAreaInsetsDidChange() {
            super.viewSafeAreaInsetsDidChange()
            self._updateSafeArea()
        }
        
        public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.container.didChangeAppearance()
        }
        
        public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            self._updateStatusBarHeight()
        }
        
    }
    
}

extension UI.ViewController : IRootContainerDelegate {
    
    public func viewController() -> UIViewController? {
        return self
    }
    
    public func updateOrientations() {
        let interfaceOrientation = self._interfaceOrientation()
        var deviceOrientation = UIDevice.current.orientation
        switch interfaceOrientation {
        case .portrait: deviceOrientation = UIDeviceOrientation.portrait
        case .portraitUpsideDown: deviceOrientation = UIDeviceOrientation.portraitUpsideDown
        case .landscapeLeft: deviceOrientation = UIDeviceOrientation.landscapeLeft
        case .landscapeRight: deviceOrientation = UIDeviceOrientation.landscapeRight
        case .unknown: break
        @unknown default: break
        }
        if deviceOrientation != UIDevice.current.orientation {
            UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
        }
    }
    
    public func updateStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
        self._updateStatusBarHeight()
    }
    
}

extension UI.ViewController : IVirtualKeyboardObserver {
    
    public func willShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
        self._updateVirtualKeyboardHeight(duration: info.duration, height: info.endFrame.height)
    }
    
    public func didShow(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
    public func willHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
        self._updateVirtualKeyboardHeight(duration: info.duration, height: 0)
    }
    
    public func didHide(virtualKeyboard: VirtualKeyboard, info: VirtualKeyboard.Info) {
    }
    
}

extension UI.ViewController : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self.container.didChangeInsets()
    }
    
}

private extension UI.ViewController {
    
    func _free() {
        self._virtualKeyboard.remove(observer: self)
        self._virtualKeyboardAnimationTask?.cancel()
        UI.Container.BarController.shared.remove(observer: self)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func _didChangeStatusBarFrame(_ notification: Any) {
        self._updateStatusBarHeight()
    }
    
    func _updateStatusBarHeight() {
        if let substrate = self.container.statusBarSubstrate {
            substrate.height = .fixed(self._statusBarHeight())
        }
    }
    
    func _statusBarHeight() -> Float {
        let height: Float
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            height = Float(window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        } else {
            height = Float(UIApplication.shared.statusBarFrame.height)
        }
        return height
    }
    
    func _updateSafeArea() {
        if self.container.isPresented == true {
            self.container.safeArea = self._safeArea()
        }
        if let containerView = self._containerView {
            containerView.layoutIfNeeded()
        }
    }
    
    func _safeArea() -> InsetFloat {
        let safeArea: InsetFloat
        if #available(iOS 11.0, *) {
            safeArea = InsetFloat(self.additionalSafeAreaInsets)
        } else {
            safeArea = InsetFloat(
                top: Float(self.topLayoutGuide.length),
                left: 0,
                right: 0,
                bottom: Float(self.bottomLayoutGuide.length)
            )
        }
        return InsetFloat(
            top: safeArea.top,
            left: safeArea.left,
            right: safeArea.right,
            bottom: max(safeArea.bottom, self.virtualKeyboardHeight)
        )
    }
    
    func _updateVirtualKeyboardHeight(duration: TimeInterval, height: Float) {
        guard abs(self.virtualKeyboardHeight - height) > .leastNonzeroMagnitude else { return }
        self._virtualKeyboardAnimationTask?.cancel()
        self._virtualKeyboardAnimationTask = Animation.default.run(
            duration: duration,
            processing: { [unowned self] progress in
                self.virtualKeyboardHeight = self.virtualKeyboardHeight.lerp(height, progress: progress)
            },
            completion: { [unowned self] in
                self.virtualKeyboardHeight = height
                self._virtualKeyboardAnimationTask = nil
            }
        )
    }
    
    func _interfaceOrientation() -> UIInterfaceOrientation {
        let supportedOrientations = self.supportedInterfaceOrientations
        switch UIDevice.current.orientation {
        case .unknown, .portrait, .faceUp, .faceDown:
            if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            } else if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            }
            break
        case .portraitUpsideDown:
            if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            } else if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            }
            break
        case .landscapeLeft:
            if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            } else if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            }
            break
        case .landscapeRight:
            if supportedOrientations.contains(.landscapeRight) == true {
                return .landscapeRight
            } else if supportedOrientations.contains(.landscapeLeft) == true {
                return .landscapeLeft
            } else if supportedOrientations.contains(.portrait) == true {
                return .portrait
            } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                return .portraitUpsideDown
            }
            break
        @unknown default:
            break
        }
        return .unknown
    }
    
}

#endif
