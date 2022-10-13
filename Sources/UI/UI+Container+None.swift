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
    
    final class None : IUIContainer, IUIContainerParentable {
        
        public unowned var parent: IUIContainer? {
            didSet {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
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
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        
        private var _view: UI.View.Empty
        
        public init(
            _ color: UI.Color = .clear
        ) {
            self.isPresented = false
            self._view = UI.View.Empty()
                .color(color)
        }
        
        public func insets(of content: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
        }
        
        public func activate() -> Bool {
            return false
        }
        
        public func didChangeAppearance() {
        }
        
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
        
    }
    
}

extension UI.Container.None : IUIRootContentContainer {
}

extension UI.Container.None : IUIStackContentContainer {
    
    public var stackBar: UI.View.StackBar {
        return .init(configure: {
            $0.size = 50
        })
    }
    
    public var stackBarVisibility: Float {
        return 1
    }
    
    public var stackBarHidden: Bool {
        return false
    }
    
}

extension UI.Container.None : IUIGroupContentContainer {
    
    public var groupItem: UI.View.GroupBar.Item {
        return .init(UI.View.Empty().color(.red).cornerRadius(.auto))
    }
    
}

extension UI.Container.None : IUIPageContentContainer {
    
    public var pageItem: UI.View.PageBar.Item {
        return .init(UI.View.Empty().color(.red).cornerRadius(.auto))
    }
    
}

extension UI.Container.None : IUIBookContentContainer {
    
    public var bookIdentifier: Any {
        return self
    }
    
}

extension UI.Container.None : IUIHamburgerContentContainer {
}

extension UI.Container.None : IHamburgerMenuContainer {
    
    public var hamburgerSize: Float {
        return 120
    }
    
    public var hamburgerLimit: Float {
        return 120
    }
    
}

extension UI.Container.None : IUIModalContentContainer {
    
    public var modalSheetInset: InsetFloat? {
        return nil
    }
    
    public var modalSheetBackground: (IUIView & IUIViewAlphable)? {
        return nil
    }
    
}

extension UI.Container.None : IUIDialogContentContainer {
    
    public var dialogInset: InsetFloat {
        return .zero
    }
    
    public var dialogWidth: DialogContentContainerSize {
        return .fill(before: 24, after: 24)
    }
    
    public var dialogHeight: DialogContentContainerSize {
        return .fill(before: 24, after: 24)
    }
    
    public var dialogAlignment: DialogContentContainerAlignment {
        return .center
    }
    
    public var dialogBackground: (IUIView & IUIViewAlphable)? {
        return nil
    }
    
}

extension UI.Container.None : IUIPushContentContainer {
    
    public var pushDuration: TimeInterval? {
        return 5
    }
    
}
