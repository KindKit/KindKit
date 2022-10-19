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
    
    #if os(iOS)
    
    func viewController() -> UIViewController?
    
    func updateOrientations()
    func updateStatusBar()
    
    #endif
    
}

public extension UI.Container {
    
    final class Root : IUIContainer {
        
        public unowned var delegate: IRootContainerDelegate?
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
                self.didChangeInsets()
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
        public var overlay: IUIRootContentContainer? {
            didSet {
                guard self.overlay !== oldValue else { return }
                if let overlay = self.overlay {
                    if self.isPresented == true {
                        overlay.prepareHide(interactive: false)
                        overlay.finishHide(interactive: false)
                    }
                    overlay.parent = nil
                }
                self._layout.overlay = self.overlay.flatMap({ UI.Layout.Item($0.view) })
                if self.isPresented == true {
                    self._layout.update()
                }
                if let overlay = self.overlay {
                    overlay.parent = self
                    if self.isPresented == true {
                        overlay.prepareShow(interactive: false)
                        overlay.finishShow(interactive: false)
                    }
                }
            }
        }
        public var content: IUIRootContentContainer {
            didSet {
                guard self.content !== oldValue else { return }
                if self.isPresented == true {
                    self.content.prepareHide(interactive: false)
                    self.content.finishHide(interactive: false)
                }
                self.content.parent = nil
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
                    self.didChangeInsets()
                }
            }
        }
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            statusBarSubstrate: (IUIView & IUIViewStaticSizeable)? = nil,
            overlay: IUIRootContentContainer? = nil,
            content: IUIRootContentContainer
        ) {
            self.isPresented = false
            self.statusBarSubstrate = statusBarSubstrate
            self.overlay = overlay
            self.content = content
            self._layout = Layout(
                statusBar: statusBarSubstrate.flatMap({ UI.Layout.Item($0) }),
                overlay: overlay.flatMap({ UI.Layout.Item($0.view) }),
                content: UI.Layout.Item(content.view)
            )
            self._view = UI.View.Custom(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
#if os(iOS)
        
        public func setNeedUpdateStatusBar() {
            self.delegate?.updateStatusBar()
        }
        
        public func setNeedUpdateOrientations() {
            self.delegate?.updateOrientations()
        }
        
#endif
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            if self.overlay === container {
                return self.safeArea
            } else if self.content === container {
                return self.safeArea
            }
            return .zero
        }
        
        public func didChangeInsets() {
            self.overlay?.didChangeInsets()
            self.content.didChangeInsets()
        }
        
        public func activate() -> Bool {
            if let overlay = self.overlay {
                if overlay.activate() == true {
                    return true
                }
            }
            return self.content.activate()
        }
        
        public func didChangeAppearance() {
            if let overlay = self.overlay {
                overlay.didChangeAppearance()
            }
            self.content.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.overlay?.prepareShow(interactive: interactive)
            self.content.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.overlay?.finishShow(interactive: interactive)
            self.content.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.overlay?.cancelShow(interactive: interactive)
            self.content.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.overlay?.prepareHide(interactive: interactive)
            self.content.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.overlay?.finishHide(interactive: interactive)
            self.content.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.overlay?.cancelHide(interactive: interactive)
            self.content.cancelHide(interactive: interactive)
        }
        
    }
    
}

private extension UI.Container.Root {
    
    func _setup() {
        self.overlay?.parent = self
        self.content.parent = self
    }
    
    func _destroy() {
    }
    
}
