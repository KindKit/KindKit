//
//  KindKit
//

import KindAnimation
import KindUI

public extension Container {
    
    final class Sticky< ContentContainer : IContainer > : IStickyContainer where ContentContainer : IContainerParentable {
        
        public weak var parent: IContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if let parent = self.parent {
                    if parent.isPresented == true {
                        self.refreshParentInset()
#if os(iOS)
                        self.orientation = parent.orientation
#endif
                    }
                } else {
                    self.refreshParentInset()
#if os(iOS)
                    self.orientation = .unknown
#endif
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
        public var orientation: UIInterfaceOrientation = .unknown {
            didSet {
                guard self.orientation != oldValue else { return }
                self.screen.didChange(orientation: self.orientation)
                self.content.didChange(orientation: self.orientation)
            }
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IView {
            return self._view
        }
        public private(set) var screen: IStickyScreen
        public private(set) var sticky: BarView {
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
        
        private var _sticky: BarView
        private var _content: ContentContainer
        private var _layout: Layout
        private var _view: CustomView
        
        public init(
            screen: IStickyScreen,
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
            self._view = CustomView()
                .content(self._layout)
            self._setup()
        }
        
        deinit {
            self._destroy()
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
            self._content.apply(contentInset: contentInset)
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            let parentInset = self.parentInset()
            if self._content === container, let stickySize = self._layout.stickySize {
                if self.stickyHidden == false && Container.BarController.shared.hidden(.sticky) == false {
                    return parentInset + .init(bottom: stickySize.height, visibility: self.stickyVisibility)
                }
            }
            return parentInset
        }
        
        public func contentInset() -> Container.AccumulateInset {
            let contentInset = self._content.contentInset()
            guard let stickySize = self._layout.stickySize else {
                return contentInset
            }
            if self.stickyHidden == false && Container.BarController.shared.hidden(.sticky) == false {
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
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
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
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func updateSticky(animated: Bool, completion: (() -> Void)?) {
            self._layout.stickyHidden = self.screen.stickyHidden
            if self.isPresented == true {
                self.refreshParentInset()
            }
        }
        
    }
    
}

private extension Container.Sticky {
    
    func _setup() {
        self.screen.container = self
        self._content.parent = self
        self.screen.setup()
        
        Container.BarController.shared.add(observer: self)
    }
    
    func _destroy() {
        Container.BarController.shared.remove(observer: self)
        
        self.screen.container = nil
        self.screen.destroy()
    }
    
}

extension Container.Sticky : IRootContentContainer {
}

extension Container.Sticky : IGroupContentContainer where ContentContainer : IGroupContentContainer {
    
    public var groupItem: GroupBarView.Item {
        return self.content.groupItem
    }
    
}

extension Container.Sticky : IStackContentContainer where ContentContainer : IStackContentContainer {
    
    public var stackBar: StackBarView {
        return self.content.stackBar
    }
    
    public var stackBarVisibility: Double {
        return self.content.stackBarVisibility
    }
    
    public var stackBarHidden: Bool {
        return self.content.stackBarHidden
    }
    
}

extension Container.Sticky : IPageContentContainer where ContentContainer : IPageContentContainer {
    
    public var pageItem: PageBarView.Item {
        return self.content.pageItem
    }
    
}

extension Container.Sticky : IDialogContentContainer where ContentContainer : IDialogContentContainer {
    
    public var dialogInset: Inset {
        return self.content.dialogInset
    }
    
    public var dialogSize: Dialog.Size {
        return self.content.dialogSize
    }
    
    public var dialogAlignment: Dialog.Alignment {
        return self.content.dialogAlignment
    }
    
    public var dialogBackground: (IView & IViewAlphable)? {
        return self.content.dialogBackground
    }
    
    public func dialogPressedOutside() {
        self.content.dialogPressedOutside()
    }
    
}

extension Container.Sticky : IModalContentContainer where ContentContainer : IModalContentContainer {
    
    public var modalColor: Color {
        return self.content.modalColor
    }
    
    public var modalSheet: Modal.Presentation.Sheet? {
        return self.content.modalSheet
    }
    
    public func modalPressedOutside() {
        self.content.modalPressedOutside()
    }
    
}

extension Container.Sticky : IHamburgerContentContainer where ContentContainer : IHamburgerContentContainer {
}

extension Container.Sticky : IContainerBarControllerObserver {
    
    public func changed(_ barController: Container.BarController) {
        self._layout.stickyVisibility = barController.visibility(.sticky)
    }
    
}
