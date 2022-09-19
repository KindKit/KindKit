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
    
    final class Screen< Screen : IUIScreen & IUIScreenViewable > : IUIScreenContainer, IUIContainerScreenable {
        
        public unowned var parent: IUIContainer? {
            didSet(oldValue) {
                guard self.parent !== oldValue else { return }
                if self.parent == nil || self.parent?.isPresented == true {
                    self.didChangeInsets()
                }
            }
        }
        public var shouldInteractive: Bool {
            return self.screen.shouldInteractive
        }
#if os(iOS)
        public var statusBarHidden: Bool {
            guard let screen = self.screen as? IScreenStatusable else { return false }
            return screen.statusBarHidden
        }
        public var statusBarStyle: UIStatusBarStyle {
            guard let screen = self.screen as? IScreenStatusable else { return .default }
            return screen.statusBarStyle
        }
        public var statusBarAnimation: UIStatusBarAnimation {
            guard let screen = self.screen as? IScreenStatusable else { return .fade }
            return screen.statusBarAnimation
        }
        public var supportedOrientations: UIInterfaceOrientationMask {
            guard let screen = self.screen as? IScreenOrientable else { return .all }
            return screen.supportedOrientations
        }
#endif
        public private(set) var isPresented: Bool
        public var view: IUIView {
            return self._view
        }
        public private(set) var screen: Screen
        
        private var _layout: Layout
        private var _view: UI.View.Custom
        
        public init(
            _ screen: Screen
        ) {
            self.isPresented = false
            self.screen = screen
            self._layout = Layout(
                fit: (screen is IUIScreenPushable) || (screen is IUIScreenDialogable)
            )
            self._view = UI.View.Custom(self._layout)
            self._init()
        }
        
        deinit {
            self.screen.destroy()
        }
        
        public func insets(of container: IUIContainer, interactive: Bool) -> InsetFloat {
            return self.inheritedInsets(interactive: interactive)
        }
        
        public func didChangeInsets() {
            self.screen.didChangeInsets()
        }
        
        public func activate() -> Bool {
            guard self.isPresented == true else { return false }
            return self.screen.activate()
        }
        
        public func didChangeAppearance() {
            self.screen.didChangeAppearance()
        }
        
        public func prepareShow(interactive: Bool) {
            self.screen.prepareShow(interactive: interactive)
        }
        
        public func finishShow(interactive: Bool) {
            self.isPresented = true
            self.screen.finishShow(interactive: interactive)
        }
        
        public func cancelShow(interactive: Bool) {
            self.screen.cancelShow(interactive: interactive)
        }
        
        public func prepareHide(interactive: Bool) {
            self.screen.prepareHide(interactive: interactive)
        }
        
        public func finishHide(interactive: Bool) {
            self.isPresented = false
            self.screen.finishHide(interactive: interactive)
        }
        
        public func cancelHide(interactive: Bool) {
            self.screen.cancelHide(interactive: interactive)
        }
        
    }
    
}

private extension UI.Container.Screen {
    
    func _init() {
        self.screen.container = self
        self.screen.setup()
        
        self._layout.item = UI.Layout.Item(self.screen.view)
    }
    
}

extension UI.Container.Screen : IUIRootContentContainer {
}

extension UI.Container.Screen : IUIStackContentContainer where Screen : IUIScreenStackable {
    
    public var stackBarView: UI.View.StackBar {
        return self.screen.stackBarView
    }
    
    public var stackBarVisibility: Float {
        return max(0, min(self.screen.stackBarVisibility, 1))
    }
    
    public var stackBarHidden: Bool {
        return self.screen.stackBarHidden
    }
    
}

extension UI.Container.Screen : IUIGroupContentContainer where Screen : IUIScreenGroupable {
    
    public var groupItemView: UI.View.GroupBar.Item {
        return self.screen.groupItemView
    }
    
}

extension UI.Container.Screen : IUIPageContentContainer where Screen : IUIScreenPageable {
    
    public var pageItemView: UI.View.PageBar.Item {
        return self.screen.pageItemView
    }
    
}

extension UI.Container.Screen : IUIBookContentContainer where Screen : IUIScreenBookable {
    
    public var bookIdentifier: Any {
        return self.screen.bookIdentifier
    }
    
}

extension UI.Container.Screen : IUIHamburgerContentContainer {
}

extension UI.Container.Screen : IHamburgerMenuContainer where Screen : IUIScreenHamburgerable {
    
    public var hamburgerSize: Float {
        return self.screen.hamburgerSize
    }
    
    public var hamburgerLimit: Float {
        return self.screen.hamburgerLimit
    }
    
}

extension UI.Container.Screen : IUIModalContentContainer where Screen : IUIScreenModalable {
    
    public var modalSheetInset: InsetFloat? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.inset
        }
    }
    
    public var modalSheetBackgroundView: (IUIView & IUIViewAlphable)? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.backgroundView
        }
    }
    
}

extension UI.Container.Screen : IUIDialogContentContainer where Screen : IUIScreenDialogable {
    
    public var dialogInset: InsetFloat {
        return self.screen.dialogInset
    }
    
    public var dialogWidth: DialogContentContainerSize {
        return self.screen.dialogWidth
    }
    
    public var dialogHeight: DialogContentContainerSize {
        return self.screen.dialogHeight
    }
    
    public var dialogAlignment: DialogContentContainerAlignment {
        return self.screen.dialogAlignment
    }
    
    public var dialogBackgroundView: (IUIView & IUIViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
}

extension UI.Container.Screen : IUIPushContentContainer where Screen : IUIScreenPushable {
    
    public var pushDuration: TimeInterval? {
        return self.screen.pushDuration
    }
    
}
