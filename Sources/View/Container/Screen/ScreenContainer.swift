//
//  KindKitView
//

import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public class ScreenContainer< Screen : IScreen & IScreenViewable > : IScreenContainer, IContainerScreenable {
    
    public unowned var parent: IContainer? {
        didSet(oldValue) {
            guard self.parent !== oldValue else { return }
            self.didChangeInsets()
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
    public var view: IView {
        return self._view
    }
    public private(set) var screen: Screen
    
    private var _view: CustomView< Layout >
    
    public init(screen: Screen) {
        self.isPresented = false
        self.screen = screen
        self._view = CustomView(
            contentLayout: Layout(
                fit: (screen is IScreenPushable) || (screen is IScreenDialogable)
            )
        )
        self._init()
    }
    
    deinit {
        self.screen.destroy()
    }
    
    public func insets(of container: IContainer, interactive: Bool) -> InsetFloat {
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
        self.didChangeInsets()
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

private extension ScreenContainer {
    
    func _init() {
        self.screen.container = self
        self.screen.setup()
        
        self._view.contentLayout.item = LayoutItem(view: self.screen.view)
    }
    
}

extension ScreenContainer : IRootContentContainer {
}

extension ScreenContainer : IStackContentContainer where Screen : IScreenStackable {
    
    public var stackBarView: IStackBarView {
        return self.screen.stackBarView
    }
    
    public var stackBarVisibility: Float {
        return max(0, min(self.screen.stackBarVisibility, 1))
    }
    
    public var stackBarHidden: Bool {
        return self.screen.stackBarHidden
    }
    
}

extension ScreenContainer : IGroupContentContainer where Screen : IScreenGroupable {
    
    public var groupItemView: IBarItemView {
        return self.screen.groupItemView
    }
    
}

extension ScreenContainer : IPageContentContainer where Screen : IScreenPageable {
    
    public var pageItemView: IBarItemView {
        return self.screen.pageItemView
    }
    
}

extension ScreenContainer : IBookContentContainer where Screen : IScreenBookable {
    
    public var bookIdentifier: Any {
        return self.screen.bookIdentifier
    }
    
}

extension ScreenContainer : IHamburgerContentContainer {
}

extension ScreenContainer : IHamburgerMenuContainer where Screen : IScreenHamburgerable {
    
    public var hamburgerSize: Float {
        return self.screen.hamburgerSize
    }
    
    public var hamburgerLimit: Float {
        return self.screen.hamburgerLimit
    }
    
}

extension ScreenContainer : IModalContentContainer where Screen : IScreenModalable {
    
    public var modalSheetInset: InsetFloat? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.inset
        }
    }
    
    public var modalSheetBackgroundView: (IView & IViewAlphable)? {
        switch self.screen.modalPresentation {
        case .simple: return nil
        case .sheet(let info): return info.backgroundView
        }
    }
    
}

extension ScreenContainer : IDialogContentContainer where Screen : IScreenDialogable {
    
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
    
    public var dialogBackgroundView: (IView & IViewAlphable)? {
        return self.screen.dialogBackgroundView
    }
    
}

extension ScreenContainer : IPushContentContainer where Screen : IScreenPushable {
    
    public var pushDuration: TimeInterval? {
        return self.screen.pushDuration
    }
    
}

private extension ScreenContainer {
    
    class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var item: LayoutItem? {
            didSet { self.setNeedUpdate() }
        }
        let fit: Bool
        
        init(
            fit: Bool
        ) {
            self.fit = fit
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if self.fit == true {
                if let item = self.item {
                    item.frame = bounds
                }
                return .zero
            }
            if let item = self.item {
                item.frame = bounds
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            if self.fit == true {
                if let item = self.item {
                    return item.size(available: available)
                }
                return .zero
            }
            return available
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            guard let item = self.item else { return [] }
            return [ item ]
        }
        
    }
    
}
