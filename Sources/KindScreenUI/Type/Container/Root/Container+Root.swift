//
//  KindKit
//

import KindAnimation
import KindUI

public protocol IRootContainerDelegate : AnyObject {
    
    func updateContentInset()
    
#if os(macOS)
    
    func viewController() -> NSViewController?
    
#elseif os(iOS)
    
    func viewController() -> UIViewController?
    
    func updateOrientations()
    func updateStatusBar()
    
#endif
    
}

public extension Container {
    
    final class Root : IContainer {
        
        public weak var delegate: IRootContainerDelegate?
        public var shouldInteractive: Bool {
            return self.content.shouldInteractive
        }
#if os(macOS)
        public var nsViewController: NSViewController? {
            return self.delegate?.viewController()
        }
#elseif os(iOS)
        public var statusBar: UIStatusBarStyle {
            return self.content.statusBar
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self.content.statusBarAnimation
        }
        public var statusBarHidden: Bool {
            return self.content.statusBarHidden
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self.content.supportedOrientations
        }
        public var uiViewController: UIViewController? {
            return self.delegate?.viewController()
        }
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                self.content.didChange(orientation: self.orientation)
            }
        }
#endif
        public private(set) var isPresented: Bool {
            didSet {
                guard self.isPresented != oldValue else { return }
                self.refreshParentInset()
            }
        }
        public var view: IView {
            return self._view
        }
        public var statusBarSubstrate: (IView & IViewStaticSizeable)? {
            didSet {
                guard self.statusBarSubstrate !== oldValue else { return }
                self._layout.statusBar = self.statusBarSubstrate
            }
        }
        public var content: IRootContentContainer {
            willSet {
                guard self.content !== newValue else { return }
                if self.isPresented == true {
                    self.content.prepareHide(interactive: false)
                    self.content.finishHide(interactive: false)
                }
                self.content.parent = nil
            }
            didSet {
                guard self.content !== oldValue else { return }
                self._layout.content = self.content.view
                if self.isPresented == true {
                    self._layout.update()
                }
                self.content.parent = self
                if self.isPresented == true {
                    self.content.prepareShow(interactive: false)
                    self.content.finishShow(interactive: false)
#if os(iOS)
                    self.refreshOrientations()
                    self.refreshStatusBar()
#endif
                }
            }
        }
        public var safeArea: Inset = .zero {
            didSet {
                guard self.safeArea != oldValue else { return }
                if self.isPresented == true {
                    self.refreshParentInset()
                }
            }
        }
        
        private var _layout: Layout
        private var _view: CustomView
        
        public init(
            statusBarSubstrate: (IView & IViewStaticSizeable)? = nil,
            content: IRootContentContainer
        ) {
            self.isPresented = false
            self.statusBarSubstrate = statusBarSubstrate
            self.content = content
            self._layout = Layout(
                statusBar: statusBarSubstrate,
                content: content.view
            )
            self._view = CustomView()
                .content(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
            self.content.apply(contentInset: contentInset)
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            if self.content === container {
                return .init(self.safeArea)
            }
            return .zero
        }
        
        public func contentInset() -> Container.AccumulateInset {
            let baseInset = Container.AccumulateInset(self.safeArea)
            let contentInset = self.content.contentInset()
            return baseInset + contentInset
        }
        
        public func refreshParentInset() {
            self.content.refreshParentInset()
        }
        
        public func refreshContentInset() {
            self.delegate?.updateContentInset()
        }
        
#if os(iOS)
        
        public func refreshStatusBar() {
            self.delegate?.updateStatusBar()
        }
        
        public func refreshOrientations() {
            self.delegate?.updateOrientations()
        }
        
#endif
        
        public func activate() -> Bool {
            return self.content.activate()
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            return self.content.snake()
        }
        
#endif
        
        public func didChangeAppearance() {
            self.content.didChangeAppearance()
        }
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
        public func prepareShow(interactive: Bool) {
            self.content.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.content.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.content.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.content.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.content.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.content.cancelHide(interactive: interactive)
        }
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
#if os(macOS)
            guard let viewController = self.nsViewController else { return false }
            guard let parentViewController = viewController.presentingViewController else { return false }
            parentViewController.dismiss(viewController)
            completion?()
            return true
#elseif os(iOS)
            guard let viewController = self.uiViewController else { return false }
            viewController.dismiss(animated: animated, completion: completion)
            return true
#else
            return false
#endif
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            return self.close(animated: animated, completion: completion)
        }
        
    }
    
}

private extension Container.Root {
    
    func _setup() {
        self.content.parent = self
    }
    
    func _destroy() {
    }

}
