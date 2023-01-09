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
        
        public weak var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.refreshParentInset()
                    }
                } else {
                    self.refreshParentInset()
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
                self._layout.sticky = newValue
            }
            get { self._sticky }
        }
        public private(set) var stickyVisibility: Double {
            set { self._layout.stickyVisibility = newValue }
            get { self._layout.stickyVisibility }
            
        }
        public private(set) var stickyHidden: Bool {
            set { self._layout.stickyHidden = newValue }
            get { self._layout.stickyHidden }
        }
        public var content: ContentContainer {
            set {
                guard self._content !== newValue else { return }
                if self.isPresented == true {
                    self._content.prepareHide(interactive: false)
                    self._content.finishHide(interactive: false)
                    self._content.refreshParentInset()
                }
                self._content.parent = nil
                self._content = newValue
                self._content.parent = self
                self._layout.content = self._content.view
                if self.isPresented == true {
                    self._content.refreshParentInset()
                    self._content.prepareShow(interactive: false)
                    self._content.finishShow(interactive: false)
                }
#if os(iOS)
                self.refreshOrientations()
                self.refreshStatusBar()
#endif
            }
            get { self._content }
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
                content: content.view,
                sticky: screen.sticky,
                stickyVisibility: screen.stickyVisibility,
                stickyHidden: screen.stickyHidden
            )
            self._view = UI.View.Custom()
                .content(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: UI.Container.AccumulateInset) {
            self._content.apply(contentInset: contentInset)
        }
        
        public func parentInset(for container: IUIContainer) -> UI.Container.AccumulateInset {
            let parentInset = self.parentInset()
            if self._content === container, let stickySize = self._layout.stickySize {
                if self.stickyHidden == false && UI.Container.BarController.shared.hidden(.sticky) == false {
                    return parentInset + .init(bottom: stickySize.height, visibility: self.stickyVisibility)
                }
            }
            return parentInset
        }
        
        public func contentInset() -> UI.Container.AccumulateInset {
            let contentInset = self._content.contentInset()
            guard let stickySize = self._layout.stickySize else {
                return contentInset
            }
            if self.stickyHidden == false && UI.Container.BarController.shared.hidden(.sticky) == false {
                return contentInset + .init(bottom: stickySize.height, visibility: self.stickyVisibility)
            }
            return contentInset
        }
        
        public func refreshParentInset() {
            let contentInset = self.contentInset()
            if self.stickyHidden == false {
                self._sticky.alpha = self.stickyVisibility
            } else {
                self._sticky.alpha = 0
            }
            self._sticky.safeArea(.init(
                top: 0,
                left: contentInset.interactive.left,
                right: contentInset.interactive.right,
                bottom: 0
            ))
            self._layout.stickyInset = contentInset.interactive.bottom
            self._content.refreshParentInset()
        }
        
        public func activate() -> Bool {
            return self._content.activate()
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            return self._content.snake()
        }
        
#endif
        
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
                self.refreshParentInset()
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
    
    public var stackBarVisibility: Double {
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
    
    public var dialogInset: Inset {
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
    
    public var modalColor: UI.Color {
        return self.content.modalColor
    }
    
    public var modalSheet: UI.Modal.Presentation.Sheet? {
        return self.content.modalSheet
    }
    
    public func modalPressedOutside() {
        self.content.modalPressedOutside()
    }
    
}

extension UI.Container.Sticky : IUIHamburgerContentContainer where ContentContainer : IUIHamburgerContentContainer {
}

extension UI.Container.Sticky : IContainerBarControllerObserver {
    
    public func changed(_ barController: UI.Container.BarController) {
        self._layout.stickyVisibility = barController.visibility(.sticky)
    }
    
}
