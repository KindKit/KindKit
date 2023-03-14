//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI {
    
    final class ViewController : UIViewController {
        
        public let container: UI.Container.Root
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
        public let onSnake: Signal.Empty< Void > = .init()
        
        private var _containerView: UIView? {
            willSet {
                guard self._containerView != newValue else { return }
                if let containerView = self._containerView {
                    containerView.removeFromSuperview()
                }
            }
            didSet {
                guard self._containerView != oldValue else { return }
                if let containerView = self._containerView {
                    containerView.frame = self.view.bounds
                    self.view.addSubview(containerView)
                    containerView.layoutIfNeeded()
                }
            }
        }
        private var _owner: AnyObject?
        
        private init(
            owner: AnyObject? = nil,
            container: UI.Container.Root
        ) {
            self.container = container
            self._owner = owner
            
            super.init(nibName: nil, bundle: nil)
            
            self.container.delegate = self
            UI.Container.BarController.shared.add(observer: self)
            
            if #available(iOS 13, *) {
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(self._didChangeStatusBarFrame(_:)), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
            }
        }
        
        public convenience init(
            _ container: UI.Container.Root
        ) {
            self.init(container: container)
        }
        
        public convenience init< Container : IUIRootContentContainer >(
            _ container: Container
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
                owner: wireframe,
                container: wireframe.container
            )
        }
        
        public convenience init< Wireframe : IUIWireframe >(
            _ wireframe: Wireframe
        ) where Wireframe : AnyObject, Wireframe.Container : IUIRootContentContainer {
            self.init(
                owner: wireframe,
                container: UI.Container.Root(
                    content: wireframe.container
                )
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
            if let containerView = self._containerView {
                containerView.frame = self.view.bounds
            }
            if self.container.isPresented == true {
                self.container.safeArea = self._safeArea()
            }
        }
        
        @available(iOS 11.0, *)
        public override func viewSafeAreaInsetsDidChange() {
            super.viewSafeAreaInsetsDidChange()
            if self.container.isPresented == true {
                self.container.safeArea = self._safeArea()
            }
        }
        
        public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.container.didChangeAppearance()
        }
        
        public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            self._updateStatusBarHeight()
        }
        
        public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                if self.container.snake() == false {
                    self.onSnake.emit()
                }
            }
        }
        
    }
    
}

public extension UI.ViewController {
    
    @inlinable
    @discardableResult
    func onSnake(_ closure: (() -> Void)?) -> Self {
        self.onSnake.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSnake(_ closure: ((Self) -> Void)?) -> Self {
        self.onSnake.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSnake< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onSnake.link(sender, closure)
        return self
    }
    
}

extension UI.ViewController : IRootContainerDelegate {
    
    public func updateContentInset() {
        let contentInset = self.container.contentInset()
        self.container.apply(contentInset: contentInset)
    }
    
    public func viewController() -> UIViewController? {
        return self
    }
    
    public func updateOrientations() {
        let supportedOrientations = self.supportedInterfaceOrientations
        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let interfaceOrientation: UIInterfaceOrientation
            let currentDeviceOrientation = UIDevice.current.orientation
            switch currentDeviceOrientation {
            case .unknown, .portrait, .faceUp, .faceDown:
                if supportedOrientations.contains(.portrait) == true {
                    interfaceOrientation = .portrait
                } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                    interfaceOrientation = .portraitUpsideDown
                } else if supportedOrientations.contains(.landscapeLeft) == true {
                    interfaceOrientation = .landscapeLeft
                } else if supportedOrientations.contains(.landscapeRight) == true {
                    interfaceOrientation = .landscapeRight
                } else {
                    interfaceOrientation = .unknown
                }
            case .portraitUpsideDown:
                if supportedOrientations.contains(.portraitUpsideDown) == true {
                    interfaceOrientation = .portraitUpsideDown
                } else if supportedOrientations.contains(.portrait) == true {
                    interfaceOrientation = .portrait
                } else if supportedOrientations.contains(.landscapeLeft) == true {
                    interfaceOrientation = .landscapeLeft
                } else if supportedOrientations.contains(.landscapeRight) == true {
                    interfaceOrientation = .landscapeRight
                } else {
                    interfaceOrientation = .unknown
                }
            case .landscapeLeft:
                if supportedOrientations.contains(.landscapeLeft) == true {
                    interfaceOrientation = .landscapeLeft
                } else if supportedOrientations.contains(.landscapeRight) == true {
                    interfaceOrientation = .landscapeRight
                } else if supportedOrientations.contains(.portrait) == true {
                    interfaceOrientation = .portrait
                } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                    interfaceOrientation = .portraitUpsideDown
                } else {
                    interfaceOrientation = .unknown
                }
            case .landscapeRight:
                if supportedOrientations.contains(.landscapeRight) == true {
                    interfaceOrientation = .landscapeRight
                } else if supportedOrientations.contains(.landscapeLeft) == true {
                    interfaceOrientation = .landscapeLeft
                } else if supportedOrientations.contains(.portrait) == true {
                    interfaceOrientation = .portrait
                } else if supportedOrientations.contains(.portraitUpsideDown) == true {
                    interfaceOrientation = .portraitUpsideDown
                } else {
                    interfaceOrientation = .unknown
                }
            @unknown default:
                interfaceOrientation = .unknown
            }
            var deviceOrientation = currentDeviceOrientation
            switch interfaceOrientation {
            case .portrait: deviceOrientation = UIDeviceOrientation.portrait
            case .portraitUpsideDown: deviceOrientation = UIDeviceOrientation.portraitUpsideDown
            case .landscapeLeft: deviceOrientation = UIDeviceOrientation.landscapeLeft
            case .landscapeRight: deviceOrientation = UIDeviceOrientation.landscapeRight
            case .unknown: break
            @unknown default: break
            }
            if deviceOrientation != currentDeviceOrientation {
                UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
            }
        }
    }
    
    public func updateStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
        self._updateStatusBarHeight()
    }
    
}

extension UI.ViewController : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self.container.refreshParentInset()
    }
    
}

private extension UI.ViewController {
    
    func _free() {
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
    
    func _statusBarHeight() -> Double {
        let height: Double
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            height = Double(window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        } else {
            height = Double(UIApplication.shared.statusBarFrame.height)
        }
        return height
    }
    
    func _safeArea() -> Inset {
        if #available(iOS 11.0, *) {
            return Inset(self.view.safeAreaInsets) + Inset(self.additionalSafeAreaInsets)
        } else {
            return Inset(
                top: Double(self.topLayoutGuide.length),
                left: 0,
                right: 0,
                bottom: Double(self.bottomLayoutGuide.length)
            )
        }
    }
    
}

#endif
