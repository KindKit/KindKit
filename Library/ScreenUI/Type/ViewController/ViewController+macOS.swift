//
//  KindKit
//

#if os(macOS)

import KindUI

public final class ViewController : NSViewController {
    
    public let owner: AnyObject?
    public let container: Container.Root
    
    var kkRootView: KKRootView! {
        didSet { self.view = self.kkRootView }
    }
    
    private init(
        owner: AnyObject? = nil,
        container: Container.Root
    ) {
        self.container = container
        self.owner = owner
        
        super.init(nibName: nil, bundle: nil)
        
        self.container.delegate = self
        Container.BarController.shared.add(observer: self)
    }
    
    public convenience init(
        _ container: Container.Root
    ) {
        self.init(container: container)
    }
    
    public convenience init(
        _ container: IRootContentContainer
    ) {
        self.init(Container.Root(
            content: container
        ))
    }
    
    public convenience init< Screen : IScreen & IScreenViewable >(
        _ screen: Screen
    ) {
        self.init(Container.Screen(screen))
    }
    
    public convenience init< Wireframe : IWireframe >(
        _ wireframe: Wireframe
    ) where Wireframe : AnyObject, Wireframe.Container == Container.Root {
        self.init(
            owner: wireframe,
            container: wireframe.container
        )
    }
    
    public convenience init< Wireframe : IWireframe >(
        _ wireframe: Wireframe
    ) where Wireframe : AnyObject, Wireframe.Container : IRootContentContainer {
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
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        self.container.safeArea = self._safeArea()
        self.kkRootView.kkContent = self.container.view.native
        if self.container.isPresented == false {
            self.container.prepareShow(interactive: false)
            self.container.finishShow(interactive: false)
        }
    }
    
    public override func viewDidDisappear() {
        if self.container.isPresented == true {
            self.container.prepareHide(interactive: false)
            self.container.finishHide(interactive: false)
        }
        self.kkRootView.kkContent = nil
        super.viewDidDisappear()
    }
    
    public override func viewDidLayout() {
        super.viewDidLayout()
        if self.container.isPresented == true {
            self.container.safeArea = self._safeArea()
        }
    }
            
}

extension ViewController {
    
    final class KKRootView : NSView {
        
        var kkContent: NSView? {
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
                    self.layoutSubtreeIfNeeded()
                }
            }
        }
        
        override var isFlipped: Bool {
            return true
        }
        
        override func layout() {
            super.layout()
            
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
    
    public func viewController() -> NSViewController? {
        return self
    }
    
}

extension ViewController : IContainerBarControllerObserver {
    
    public func changed(_ barController: Container.BarController) {
        self.container.refreshParentInset()
    }
    
}

private extension ViewController {
    
    func _free() {
        Container.BarController.shared.remove(observer: self)
    }
    
    func _safeArea() -> Inset {
        let safeArea: Inset
        if #available(macOS 11.0, *) {
            safeArea = Inset(self.view.safeAreaInsets) + Inset(self.view.additionalSafeAreaInsets)
        } else {
            safeArea = .zero
        }
        return safeArea
    }
    
}

#endif
