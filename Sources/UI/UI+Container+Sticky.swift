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
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.didChangeInsets()
                    }
                } else {
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
        public private(set) var sticky: UI.View.Bar {
            set {
                guard self._sticky !== newValue else { return }
                self._layout.sticky = UI.Layout.Item(newValue)
            }
            get { return self._sticky }
        }
        public private(set) var stickyVisibility: Float {
            set { self._layout.stickyVisibility = newValue }
            get { return self._layout.stickyVisibility }
            
        }
        public private(set) var stickyHidden: Bool {
            set { self._layout.stickyHidden = newValue }
            get { return self._layout.stickyHidden }
        }
        public var content: ContentContainer {
            set {
                guard self._content !== newValue else { return }
                if self.isPresented == true {
                    self._content.prepareHide(interactive: false)
                    self._content.finishHide(interactive: false)
                    self._content.didChangeInsets()
                }
                self._content.parent = nil
                self._content = newValue
                self._content.parent = self
                self._layout.content = UI.Layout.Item(self._content.view)
                if self.isPresented == true {
                    self._content.didChangeInsets()
                    self._content.prepareShow(interactive: false)
                    self._content.finishShow(interactive: false)
                }
#if os(iOS)
                self.setNeedUpdateOrientations()
                self.setNeedUpdateStatusBar()
#endif
            }
            get { return self._content }
        }
        
        private var _sticky: UI.View.Bar
        private var _content: ContentContainer
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            screen: IUIStickyScreen,
            content: ContentContainer
        ) {
            self.screen = screen
            self.isPresented = false
            self._sticky = screen.sticky
            self._content = content
            self._layout = Layout(
                content: UI.Layout.Item(content.view),
                sticky: UI.Layout.Item(screen.sticky),
                stickyVisibility: screen.stickyVisibility,
                stickyHidden: screen.stickyHidden
            )
            self._view = UI.View.Custom(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            let inheritedInsets = self.inheritedInsets(interactive: interactive)
            if self._content === container, let stickySize = self._layout.stickySize {
                let bottom: Float
                if self.stickyHidden == false && UI.Container.BarController.shared.hidden(.sticky) == false {
                    if interactive == true {
                        bottom = stickySize.height * self.stickyVisibility
                    } else {
                        bottom = stickySize.height
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
            if self.stickyHidden == false {
                self._sticky.alpha = self.stickyVisibility
            } else {
                self._sticky.alpha = 0
            }
            self._sticky.safeArea(InsetFloat(top: 0, left: inheritedInsets.left, right: inheritedInsets.right, bottom: 0))
            self._layout.stickyInset = inheritedInsets.bottom
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
        
        public func updateSticky(animated: Bool, completion: (() -> Void)?) {
            self._layout.stickyHidden = self.screen.stickyHidden
            if self.isPresented == true {
                self.didChangeInsets()
            }
        }
        
    }
    
}

private extension UI.Container.Sticky {
    
    func _setup() {
        self.screen.container = self
        self._content.parent = self
        self.screen.setup()
        
        UI.Container.BarController.shared.add(observer: self)
    }
    
    func _destroy() {
        UI.Container.BarController.shared.remove(observer: self)
        
        self.screen.container = nil
        self.screen.destroy()
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
        self._layout.stickyVisibility = barController.visibility(.sticky)
    }
    
}
