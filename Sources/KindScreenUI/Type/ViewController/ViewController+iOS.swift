//
//  KindKit
//

#if os(iOS)

import KindEvent
import KindUI
import KindMonadicMacro

@KindMonadic
public final class ViewController : UIViewController {
    
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
    
    public let owner: AnyObject?
    
    public let container: Container.Root
    
    @KindMonadicSignal
    public let onSnake = Signal< Void, Void >()
    
    var kkRootView: KKRootView! {
        didSet { self.view = self.kkRootView }
    }
    var kkOrientation: UIInterfaceOrientation = .unknown {
        didSet {
            guard self.kkOrientation != oldValue else { return }
            self.container.didChange(orientation: self.kkOrientation)
        }
    }
    
    private init(
        owner: AnyObject? = nil,
        container: Container.Root
    ) {
        self.container = container
        self.owner = owner
        
        super.init(nibName: nil, bundle: nil)
        
        self._setup()
    }
    
    public convenience init(
        _ container: Container.Root
    ) {
        self.init(container: container)
    }
    
    public convenience init< ContainerType : IRootContentContainer >(
        _ container: ContainerType
    ) {
        self.init(Container.Root(
            content: container
        ))
    }
    
    public convenience init< ScreenType : IScreen & IScreenViewable >(
        _ screen: ScreenType
    ) {
        self.init(Container.Screen(screen))
    }
    
    public convenience init< WireframeType : IWireframe >(
        _ wireframe: WireframeType
    ) where WireframeType : AnyObject, WireframeType.Container == Container.Root {
        self.init(
            owner: wireframe,
            container: wireframe.container
        )
    }
    
    public convenience init< WireframeType : IWireframe >(
        _ wireframe: WireframeType
    ) where WireframeType : AnyObject, WireframeType.Container : IRootContentContainer {
        self.init(
            owner: wireframe,
            container: Container.Root(
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
    
    public override func loadView() {
        self.kkRootView = .init(
            frame: .init(
                origin: .zero,
                size: self.preferredContentSize
            )
        )
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._updateStatusBarHeight()
        self._updateSafeArea()
        self._updateOrientation()
        self.kkRootView.kkContent = self.container.view.native
        if self.container.isPresented == false {
            self.container.prepareShow(interactive: false)
            self.container.finishShow(interactive: false)
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._updateStatusBarHeight()
        self._updateOrientation()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        if self.container.isPresented == true {
            self.container.prepareHide(interactive: false)
            self.container.finishHide(interactive: false)
        }
        self.kkRootView.kkContent = nil
        super.viewDidDisappear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self._updateSafeArea()
    }
    
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
        self._updateOrientation()
    }
    
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if self.container.snake() == false {
                self.onSnake.emit()
            }
        }
    }
    
}

extension ViewController {
    
    final class KKRootView : UIView {
        
        var kkContent: UIView? {
            willSet {
                guard self.kkContent !== newValue else { return }
                if let content = self.kkContent {
                    content.removeFromSuperview()
                }
            }
            didSet {
                guard self.kkContent !== oldValue else { return }
                if let content = self.kkContent {
                    content.frame = self.bounds
                    self.addSubview(content)
                    self.layoutIfNeeded()
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.clipsToBounds = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            if let content = self.kkContent {
                content.frame = self.bounds
            }
        }
        
    }
    
}

extension ViewController : IRootContainerDelegate {
    
    public func updateContentInset() {
        let contentInset = self.container.contentInset()
        self.container.apply(contentInset: contentInset)
    }
    
    public func viewController() -> UIViewController? {
        return self
    }
    
    public func updateOrientations() {
        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let device = UIDevice.current
            let interfaceOrientation = device.kk_interfaceOrientation(
                supported: self.supportedInterfaceOrientations
            )
            let oldDeviceOrientation = device.orientation
            let newDeviceOrientation = device.kk_deviceOrientation(
                interfaceOrientation: interfaceOrientation
            )
            if newDeviceOrientation != oldDeviceOrientation {
                UIDevice.current.setValue(newDeviceOrientation.rawValue, forKey: "orientation")
            }
        }
    }
    
    public func updateStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
        self._updateStatusBarHeight()
    }
    
}

extension ViewController : IContainerBarControllerObserver {
    
    public func changed(_ barController: Container.BarController) {
        self.container.refreshParentInset()
    }
    
}

private extension ViewController {
    
    func _setup() {
        self.container.delegate = self
        Container.BarController.shared.add(observer: self)
    }
    
    func _free() {
        Container.BarController.shared.remove(observer: self)
    }
    
    func _updateStatusBarHeight() {
        if let substrate = self.container.statusBarSubstrate {
            substrate.height = .fixed(self._statusBarHeight())
        }
    }
    
    func _statusBarHeight() -> Double {
        let window = UIApplication.shared.kk_keyWindow
        return Double(window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
    }
    
    func _updateSafeArea() {
        self.container.safeArea = self._safeArea()
    }
    
    func _safeArea() -> Inset {
        return Inset(self.view.safeAreaInsets) + Inset(self.additionalSafeAreaInsets)
    }
    
    func _updateOrientation() {
        if let windowScene = self.view.window?.windowScene {
            self.kkOrientation = windowScene.interfaceOrientation
        } else if let windowScene = UIApplication.shared.kk_windowScenes.first {
            self.kkOrientation = windowScene.interfaceOrientation
        }
    }
    
}

#endif
