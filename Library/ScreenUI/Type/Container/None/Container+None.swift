//
//  KindKit
//

import KindUI

public extension Container {
    
    final class None : IContainer, IContainerParentable {
        
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
            return false
        }
#if os(iOS)
        public var statusBar: UIStatusBarStyle {
            return .default
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            return .fade
        }
        public var statusBarHidden: Bool {
            return false
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            return .all
        }
        public var orientation: UIInterfaceOrientation = .unknown
#endif
        public private(set) var isPresented: Bool
        public var view: IView {
            return self._view
        }
        
        private var _view: RectView
        private var _parentInset: Container.AccumulateInset = .zero {
            didSet {
                guard self._parentInset != oldValue else { return }
                self.refreshContentInset()
            }
        }
        
        public init(
            _ color: Color = .clear
        ) {
            self.isPresented = false
            self._view = RectView()
                .fill(color)
        }
        
        public func apply(contentInset: Container.AccumulateInset) {
        }
        
        public func parentInset(for container: IContainer) -> Container.AccumulateInset {
            return self.parentInset()
        }
        
        public func contentInset() -> Container.AccumulateInset {
            return .zero
        }
        
        public func refreshParentInset() {
            self._parentInset = self.parentInset()
        }
        
        public func activate() -> Bool {
            return false
        }
        
#if os(iOS)
        
        public func snake() -> Bool {
            return false
        }
        
#endif
        
        public func didChangeAppearance() {
        }
        
#if os(iOS)
        
        public func didChange(orientation: UIInterfaceOrientation) {
            self.orientation = orientation
        }
        
#endif
        
        public func prepareShow(interactive: Bool) {
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
        }
        
        public func cancelShow(interactive: Bool) {
        }
        
        public func prepareHide(interactive: Bool) {
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
        }
        
        public func cancelHide(interactive: Bool) {
        }
        
        public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
        public func close(container: IContainer, animated: Bool, completion: (() -> Void)?) -> Bool {
            guard let parent = self.parent else { return false }
            return parent.close(container: self, animated: animated, completion: completion)
        }
        
    }
    
}

extension Container.None : IRootContentContainer {
}

extension Container.None : IGroupContentContainer {
    
    public var groupItem: GroupBarView.Item {
        let rect = RectView()
            .fill(.red)
            .cornerRadius(.auto)
        return .init()
            .content(rect)
    }
    
}

extension Container.None : IPageContentContainer {
    
    public var pageItem: PageBarView.Item {
        let rect = RectView()
            .fill(.red)
            .cornerRadius(.auto)
        return .init()
            .content(rect)
    }
    
}

extension Container.None : IStackContentContainer {
    
    public var stackBar: StackBarView { .init().size(50) }
    public var stackBarVisibility: Double { 1 }
    public var stackBarHidden: Bool { false }
    
}

extension Container.None : IBookContentContainer {
    
    public var bookIdentifier: Any { self }
    
}

extension Container.None : IHamburgerContentContainer {
}

extension Container.None : IHamburgerMenuContainer {
    
    public var hamburgerSize: Double { 120 }
    public var hamburgerLimit: Double { 120 }
    
}

extension Container.None : IModalContentContainer {
    
    public var modalColor: Color { .white }
    public var modalSheet: Modal.Presentation.Sheet? { nil }
    public func modalPressedOutside() {}
    
}

extension Container.None : IDialogContentContainer {
    
    public var dialogInset: Inset { .zero }
    public var dialogSize: Dialog.Size { .init(.fill(before: 24, after: 24), .fill(before: 24, after: 24)) }
    public var dialogAlignment: Dialog.Alignment { .center }
    public var dialogBackground: (IView & IViewAlphable)? { nil }
    public func dialogPressedOutside() {}
    
}

extension Container.None : IPushContentContainer {
    
    public var pushPlacement: Push.Placement { .top }
    public var pushOptions: Push.Options { [] }
    public var pushDuration: TimeInterval? { 5 }
    
}
