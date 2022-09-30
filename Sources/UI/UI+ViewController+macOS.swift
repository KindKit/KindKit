//
//  KindKit
//

#if os(macOS)

import AppKit

public extension UI {
    
    final class ViewController : NSViewController {
        
        public let container: UI.Container.Root
        
        private var _containerView: NSView? {
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
                }
            }
        }
        private var _owner: AnyObject?
        
        private init(
            container: UI.Container.Root,
            owner: AnyObject? = nil
        ) {
            self.container = container
            self._owner = owner
            
            super.init(nibName: nil, bundle: nil)
            
            self.container.delegate = self
            UI.Container.BarController.shared.add(observer: self)
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
        
        public override func loadView() {
            self.view = NSView(frame: .zero)
        }
        
        public override func viewWillAppear() {
            super.viewWillAppear()
            self.container.safeArea = self._safeArea()
            self._containerView = self.container.view.native
            if self.container.isPresented == false {
                self.container.prepareShow(interactive: false)
                self.container.finishShow(interactive: false)
            }
        }
        
        public override func viewDidDisappear() {
            self._containerView = nil
            super.viewDidDisappear()
        }
        
        public override func viewDidLayout() {
            super.viewDidLayout()
            if let containerView = self._containerView {
                containerView.frame = self.view.bounds
            }
            self._updateSafeArea()
        }
                
    }
    
}

extension UI.ViewController : IRootContainerDelegate {
}

extension UI.ViewController : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self.container.didChangeInsets()
    }
    
}

private extension UI.ViewController {
    
    func _free() {
        UI.Container.BarController.shared.remove(observer: self)
        NotificationCenter.default.removeObserver(self)
    }
        
    func _updateSafeArea() {
        if self.container.isPresented == true {
            self.container.safeArea = self._safeArea()
        }
        if let containerView = self._containerView {
            containerView.layoutSubtreeIfNeeded()
        }
    }
    
    func _safeArea() -> InsetFloat {
        let safeArea: InsetFloat
        if #available(macOS 11.0, *) {
            safeArea = InsetFloat(self.view.safeAreaInsets) + InsetFloat(self.view.additionalSafeAreaInsets)
        } else {
            safeArea = .zero
        }
        return safeArea
    }
    
}

#endif
