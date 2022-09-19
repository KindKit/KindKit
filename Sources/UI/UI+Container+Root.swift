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
            return self.contentContainer.shouldInteractive
        }
#if os(iOS)
        public var statusBarHidden: Bool {
            return self.contentContainer.statusBarHidden
        }
        public var statusBarStyle: UIStatusBarStyle {
            return self.contentContainer.statusBarStyle
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return self.contentContainer.statusBarAnimation
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return self.contentContainer.supportedOrientations
        }
        public var viewController: UIViewController? {
            return self.delegate?.viewController()
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public var statusBarView: (IUIView & IUIViewStaticSizeable)? {
            didSet(oldValue) {
                guard self.statusBarView !== oldValue else { return }
                self._layout.statusBarItem = self.statusBarView.flatMap({ UI.Layout.Item($0) })
            }
        }
        public var safeArea: InsetFloat {
            didSet(oldValue) {
                guard self.safeArea != oldValue else { return }
                self.didChangeInsets()
            }
        }
        public var overlayContainer: IUIRootContentContainer? {
            didSet(oldValue) {
                guard self.overlayContainer !== oldValue else { return }
                if let overlayContainer = self.overlayContainer {
                    if self.isPresented == true {
                        overlayContainer.prepareHide(interactive: false)
                        overlayContainer.finishHide(interactive: false)
                    }
                    overlayContainer.parent = nil
                }
                self._layout.overlayItem = self.overlayContainer.flatMap({ UI.Layout.Item($0.view) })
                if let overlayContainer = self.overlayContainer {
                    overlayContainer.parent = self
                    if self.isPresented == true {
                        overlayContainer.prepareShow(interactive: false)
                        overlayContainer.finishShow(interactive: false)
                    }
                }
            }
        }
        public var contentContainer: IUIRootContentContainer {
            didSet(oldValue) {
                guard self.contentContainer !== oldValue else { return }
                if self.isPresented == true {
                    self.contentContainer.prepareHide(interactive: false)
                    self.contentContainer.finishHide(interactive: false)
                }
                self.contentContainer.parent = nil
                self._layout.contentItem = UI.Layout.Item(self.contentContainer.view)
                self.contentContainer.parent = self
                if self.isPresented == true {
                    self.contentContainer.prepareShow(interactive: false)
                    self.contentContainer.finishShow(interactive: false)
                }
            }
        }
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            statusBarView: (IUIView & IUIViewStaticSizeable)? = nil,
            overlayContainer: IUIRootContentContainer? = nil,
            contentContainer: IUIRootContentContainer
        ) {
            self.isPresented = false
            self.statusBarView = statusBarView
            self.overlayContainer = overlayContainer
            self.contentContainer = contentContainer
            self.safeArea = .zero
            self._layout = Layout(
                statusBarItem: statusBarView.flatMap({ UI.Layout.Item($0) }),
                overlayItem: self.overlayContainer.flatMap({ UI.Layout.Item($0.view) }),
                contentItem: UI.Layout.Item(contentContainer.view)
            )
            self._view = UI.View.Custom(self._layout)
            self._init()
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
            if self.overlayContainer === container {
                return self.safeArea
            } else if self.contentContainer === container {
                return self.safeArea
            }
            return .zero
        }
        
        public func didChangeInsets() {
            self.overlayContainer?.didChangeInsets()
            self.contentContainer.didChangeInsets()
        }
        
        public func activate() -> Bool {
            if let overlayContainer = self.overlayContainer {
                if overlayContainer.activate() == true {
                    return true
                }
            }
            return self.contentContainer.activate()
        }
        
        public func didChangeAppearance() {
            if let overlayContainer = self.overlayContainer {
                overlayContainer.didChangeAppearance()
            }
            self.contentContainer.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.overlayContainer?.prepareShow(interactive: interactive)
            self.contentContainer.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.overlayContainer?.finishShow(interactive: interactive)
            self.contentContainer.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.overlayContainer?.cancelShow(interactive: interactive)
            self.contentContainer.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.overlayContainer?.prepareHide(interactive: interactive)
            self.contentContainer.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.overlayContainer?.finishHide(interactive: interactive)
            self.contentContainer.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.overlayContainer?.cancelHide(interactive: interactive)
            self.contentContainer.cancelHide(interactive: interactive)
        }
        
    }
    
}

private extension UI.Container.Root {
    
    func _init() {
        self.overlayContainer?.parent = self
        self.contentContainer.parent = self
    }
    
}
