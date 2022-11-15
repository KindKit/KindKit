//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public protocol IRootContainerDelegate : AnyObject {
    
    func updateContentInset()
    
#if os(iOS)
    
    func viewController() -> UIViewController?
    
    func updateOrientations()
    func updateStatusBar()
    
#endif
    
}

public extension UI.Container {
    
    final class Root : IUIContainer {
        
        public weak var delegate: IRootContainerDelegate?
        public var shouldInteractive: Bool {
            return self.content.shouldInteractive
        }
#if os(iOS)
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
#endif
        public private(set) var isPresented: Bool {
            didSet {
                guard self.isPresented != oldValue else { return }
                self.refreshParentInset()
            }
        }
        public var view: IUIView {
            return self._view
        }
        public var statusBarSubstrate: (IUIView & IUIViewStaticSizeable)? {
            didSet {
                guard self.statusBarSubstrate !== oldValue else { return }
                self._layout.statusBar = self.statusBarSubstrate.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var content: IUIRootContentContainer {
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
                self._layout.content = UI.Layout.Item(self.content.view)
                if self.isPresented == true {
                    self._layout.update()
                }
                self.content.parent = self
                if self.isPresented == true {
                    self.content.prepareShow(interactive: false)
                    self.content.finishShow(interactive: false)
                }
            }
        }
        public var safeArea: InsetFloat = .zero {
            didSet {
                guard self.safeArea != oldValue else { return }
                if self.isPresented == true {
                    self.refreshParentInset()
                }
            }
        }
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            statusBarSubstrate: (IUIView & IUIViewStaticSizeable)? = nil,
            content: IUIRootContentContainer
        ) {
            self.isPresented = false
            self.statusBarSubstrate = statusBarSubstrate
            self.content = content
            self._layout = Layout(
                statusBar: statusBarSubstrate.flatMap({ UI.Layout.Item($0) }),
                content: UI.Layout.Item(content.view)
            )
            self._view = UI.View.Custom()
                .content(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: UI.Container.Inset) {
            self.content.apply(contentInset: contentInset)
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.Inset {
            if self.content === container {
                return .init(self.safeArea)
            }
            return .zero
        }
        
        public func contentInset() -> UI.Container.Inset {
            let baseInset = UI.Container.Inset(self.safeArea)
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
        
        public func didChangeAppearance() {
            self.content.didChangeAppearance()
        }
        
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
        
    }
    
}

private extension UI.Container.Root {
    
    func _setup() {
        self.content.parent = self
    }
    
    func _destroy() {
    }
    
}
