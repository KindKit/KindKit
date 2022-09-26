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
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public private(set) var screen: IUIStickyScreen
        public private(set) var overlay: UI.View.Bar {
            set(value) {
                guard self._overlay !== value else { return }
                self._layout.overlay = UI.Layout.Item(self._overlay)
            }
            get { return self._overlay }
        }
        public private(set) var overlayVisibility: Float {
            set(value) { self._layout.overlayVisibility = value }
            get { return self._layout.overlayVisibility }
            
        }
        public private(set) var overlayHidden: Bool {
            set(value) { self._layout.overlayHidden = value }
            get { return self._layout.overlayHidden }
        }
        public var content: ContentContainer {
            set(value) {
                guard self._content !== value else { return }
                if self.isPresented == true {
                    self._content.prepareHide(interactive: false)
                    self._content.finishHide(interactive: false)
                }
                self._content.parent = nil
                self._content = value
                self._content.parent = self
                self._layout.content = UI.Layout.Item(self._content.view)
                if self.isPresented == true {
                    self._content.prepareShow(interactive: false)
                    self._content.finishShow(interactive: false)
                }
#if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
#endif
                self.didChangeInsets()
            }
            get { return self._content }
        }
        
        private var _overlay: UI.View.Bar
        private var _content: ContentContainer
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            screen: IUIStickyScreen,
            content: ContentContainer
        ) {
            self.screen = screen
            self.isPresented = false
            self._overlay = screen.sticky
            self._content = content
            self._layout = Layout(
                content: UI.Layout.Item(content.view),
                overlay: UI.Layout.Item(screen.sticky),
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
            if self._content === container, let overlaySize = self._layout.overlaySize {
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
                self._overlay.alpha = self.overlayVisibility
            } else {
                self._overlay.alpha = 0
            }
            self._overlay.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
            self._layout.overlayInset = inheritedInsets.bottom
            self._content.didChangeInsets()
        }
        
        public func activate() -> Bool {
            return self._content.activate()
        }
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
            self._content.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.screen.prepareShow(interactive: interactive)
            self._content.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.screen.finishShow(interactive: interactive)
            self._content.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.screen.cancelShow(interactive: interactive)
            self._content.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.screen.prepareHide(interactive: interactive)
            self._content.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.screen.finishHide(interactive: interactive)
            self._content.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
            self._content.cancelHide(interactive: interactive)
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
        self._content.parent = self
        self.screen.setup()
    }
    
}

extension UI.Container.Sticky : IUIRootContentContainer {
}

extension UI.Container.Sticky : IUIGroupContentContainer where ContentContainer : IUIGroupContentContainer {
    
    public var groupItem: UI.View.GroupBar.Item {
        return self.content.groupItem
    }
    
}

extension UI.Container.Sticky : IUIStackContentContainer where ContentContainer : IUIStackContentContainer {
    
    public var stackBar: UI.View.StackBar {
        return self.content.stackBar
    }
    
    public var stackBarVisibility: Float {
        return self.content.stackBarVisibility
    }
    
    public var stackBarHidden: Bool {
        return self.content.stackBarHidden
    }
    
}

extension UI.Container.Sticky : IUIPageContentContainer where ContentContainer : IUIPageContentContainer {
    
    public var pageItem: UI.View.PageBar.Item {
        return self.content.pageItem
    }
    
}

extension UI.Container.Sticky : IUIDialogContentContainer where ContentContainer : IUIDialogContentContainer {
    
    public var dialogInset: InsetFloat {
        return self.content.dialogInset
    }
    
    public var dialogWidth: DialogContentContainerSize {
        return self.content.dialogWidth
    }
    
    public var dialogHeight: DialogContentContainerSize {
        return self.content.dialogHeight
    }
    
    public var dialogAlignment: DialogContentContainerAlignment {
        return self.content.dialogAlignment
    }
    
    public var dialogBackground: (IUIView & IUIViewAlphable)? {
        return self.content.dialogBackground
    }
    
}

extension UI.Container.Sticky : IUIModalContentContainer where ContentContainer : IUIModalContentContainer {
    
    public var modalSheetInset: InsetFloat? {
        return self.content.modalSheetInset
    }
    
    public var modalSheetBackground: (IUIView & IUIViewAlphable)? {
        return self.content.modalSheetBackground
    }
    
}

extension UI.Container.Sticky : IUIHamburgerContentContainer where ContentContainer : IUIHamburgerContentContainer {
}

extension UI.Container.Sticky : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self._layout.overlayVisibility = barController.visibility(.sticky)
    }
    
}
