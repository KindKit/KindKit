//
//  KindKit
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public extension UI.Container {
    
    final class Sticky< ContentContainer : IUIContainer > : IUIStickyContainer where ContentContainer : IUIContainerParentable {
        
        public unowned var parent: IUIContainer? {
            didSet(oldValue) {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
                }
            }
        }
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
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public private(set) var screen: IUIStickyScreen
        public private(set) var overlayView: UI.View.Bar {
            set(value) {
                guard self._overlayView !== value else { return }
                self._layout.overlayItem = UI.Layout.Item(self._overlayView)
            }
            get { return self._overlayView }
        }
        public private(set) var overlayVisibility: Float {
            set(value) { self._layout.overlayVisibility = value }
            get { return self._layout.overlayVisibility }
            
        }
        public private(set) var overlayHidden: Bool {
            set(value) { self._layout.overlayHidden = value }
            get { return self._layout.overlayHidden }
        }
        public var contentContainer: ContentContainer {
            set(value) {
                guard self._contentContainer !== value else { return }
                if self.isPresented == true {
                    self._contentContainer.prepareHide(interactive: false)
                    self._contentContainer.finishHide(interactive: false)
                }
                self._contentContainer.parent = nil
                self._contentContainer = value
                self._contentContainer.parent = self
                self._layout.contentItem = UI.Layout.Item(self._contentContainer.view)
                if self.isPresented == true {
                    self._contentContainer.prepareShow(interactive: false)
                    self._contentContainer.finishShow(interactive: false)
                }
#if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
#endif
                self.didChangeInsets()
            }
            get { return self._contentContainer }
        }
        
        private var _overlayView: UI.View.Bar
        private var _contentContainer: ContentContainer
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            screen: IUIStickyScreen,
            contentContainer: ContentContainer
        ) {
            self.screen = screen
            self.isPresented = false
            self._overlayView = screen.stickyView
            self._contentContainer = contentContainer
            self._layout = Layout(
                contentItem: UI.Layout.Item(contentContainer.view),
                overlayItem: UI.Layout.Item(screen.stickyView),
                overlayVisibility: screen.stickyVisibility,
                overlayHidden: screen.stickyHidden
            )
            self._view = UI.View.Custom(self._layout)
            self._init()
            UI.Container.BarController.shared.add(observer: self)
        }
        
        deinit {
            UI.Container.BarController.shared.remove(observer: self)
            self.screen.destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            let inheritedInsets = self.inheritedInsets(interactive: interactive)
            if self._contentContainer === container, let overlaySize = self._layout.overlaySize {
                let bottom: Float
                if self.overlayHidden == false && UI.Container.BarController.shared.hidden(.sticky) == false {
                    if interactive == true {
                        bottom = overlaySize.height * self.overlayVisibility
                    } else {
                        bottom = overlaySize.height
                    }
                } else {
                    bottom = 0
                }
                return InsetFloat(
                    top: inheritedInsets.top,
                    left: inheritedInsets.left,
                    right: inheritedInsets.right,
                    bottom: inheritedInsets.bottom + bottom
                )
            }
            return inheritedInsets
        }
        
        public func didChangeInsets() {
            let inheritedInsets = self.inheritedInsets(interactive: true)
            if self.overlayHidden == false {
                self._overlayView.alpha = self.overlayVisibility
            } else {
                self._overlayView.alpha = 0
            }
            self._overlayView.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
            self._layout.overlayInset = inheritedInsets.bottom
            self._contentContainer.didChangeInsets()
        }
        
        public func activate() -> Bool {
            return self._contentContainer.activate()
        }
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
            self._contentContainer.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.screen.prepareShow(interactive: interactive)
            self._contentContainer.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.screen.finishShow(interactive: interactive)
            self._contentContainer.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.screen.cancelShow(interactive: interactive)
            self._contentContainer.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.screen.prepareHide(interactive: interactive)
            self._contentContainer.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.screen.finishHide(interactive: interactive)
            self._contentContainer.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
            self._contentContainer.cancelHide(interactive: interactive)
        }
        
        public func updateOverlay(animated: Bool, completion: (() -> Void)?) {
            self._layout.overlayHidden = self.screen.stickyHidden
            self.didChangeInsets()
        }
        
    }
    
}

private extension UI.Container.Sticky {
    
    func _init() {
        self.screen.container = self
        self._contentContainer.parent = self
        self.screen.setup()
    }
    
}

extension UI.Container.Sticky : IUIRootContentContainer {
}

extension UI.Container.Sticky : IUIGroupContentContainer where ContentContainer : IUIGroupContentContainer {
    
    public var groupItemView: UI.View.GroupBar.Item {
        return self.contentContainer.groupItemView
    }
    
}

extension UI.Container.Sticky : IUIStackContentContainer where ContentContainer : IUIStackContentContainer {
    
    public var stackBarView: UI.View.StackBar {
        return self.contentContainer.stackBarView
    }
    
    public var stackBarVisibility: Float {
        return self.contentContainer.stackBarVisibility
    }
    
    public var stackBarHidden: Bool {
        return self.contentContainer.stackBarHidden
    }
    
}

extension UI.Container.Sticky : IUIPageContentContainer where ContentContainer : IUIPageContentContainer {
    
    public var pageItemView: UI.View.PageBar.Item {
        return self.contentContainer.pageItemView
    }
    
}

extension UI.Container.Sticky : IUIDialogContentContainer where ContentContainer : IUIDialogContentContainer {
    
    public var dialogInset: InsetFloat {
        return self.contentContainer.dialogInset
    }
    
    public var dialogWidth: DialogContentContainerSize {
        return self.contentContainer.dialogWidth
    }
    
    public var dialogHeight: DialogContentContainerSize {
        return self.contentContainer.dialogHeight
    }
    
    public var dialogAlignment: DialogContentContainerAlignment {
        return self.contentContainer.dialogAlignment
    }
    
    public var dialogBackgroundView: (IUIView & IUIViewAlphable)? {
        return self.contentContainer.dialogBackgroundView
    }
    
}

extension UI.Container.Sticky : IUIModalContentContainer where ContentContainer : IUIModalContentContainer {
    
    public var modalSheetInset: InsetFloat? {
        return self.contentContainer.modalSheetInset
    }
    
    public var modalSheetBackgroundView: (IUIView & IUIViewAlphable)? {
        return self.contentContainer.modalSheetBackgroundView
    }
    
}

extension UI.Container.Sticky : IUIHamburgerContentContainer where ContentContainer : IUIHamburgerContentContainer {
}

extension UI.Container.Sticky : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self._layout.overlayVisibility = barController.visibility(.sticky)
    }
    
}
