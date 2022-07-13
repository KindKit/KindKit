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

public class StickyContainer< Screen : IStickyScreen, ContentContainer : IContainer > : IStickyContainer where ContentContainer : IContainerParentable {
    
    public unowned var parent: IContainer? {
        didSet(oldValue) {
            guard self.parent !== oldValue else { return }
            self.didChangeInsets()
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
    public var view: IView {
        return self._view
    }
    public private(set) var screen: Screen
    public private(set) var overlayView: IBarView {
        set(value) {
            guard self._overlayView !== value else { return }
            self._view.contentLayout.overlayItem = LayoutItem(view: self._overlayView)
        }
        get { return self._overlayView }
    }
    public private(set) var overlayVisibility: Float {
        set(value) { self._view.contentLayout.overlayVisibility = value }
        get { return self._view.contentLayout.overlayVisibility }
        
    }
    public private(set) var overlayHidden: Bool {
        set(value) { self._view.contentLayout.overlayHidden = value }
        get { return self._view.contentLayout.overlayHidden }
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
            self._view.contentLayout.contentItem = LayoutItem(view: self._contentContainer.view)
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
    
    private var _view: CustomView< Layout >
    private var _overlayView: IBarView
    private var _contentContainer: ContentContainer
    
    public init(
        screen: Screen,
        contentContainer: ContentContainer
    ) {
        self.screen = screen
        self.isPresented = false
        self._view = CustomView(
            contentLayout: Layout(
                contentItem: LayoutItem(view: contentContainer.view),
                overlayItem: LayoutItem(view: screen.stickyView),
                overlayVisibility: screen.stickyVisibility,
                overlayHidden: screen.stickyHidden
            )
        )
        self._overlayView = screen.stickyView
        self._contentContainer = contentContainer
        self._init()
        ContainerBarController.shared.add(observer: self)
    }
    
    deinit {
        ContainerBarController.shared.remove(observer: self)
        self.screen.destroy()
    }
    
    public func insets(of container: IContainer, interactive: Bool) -> InsetFloat {
        let inheritedInsets = self.inheritedInsets(interactive: interactive)
        if self._contentContainer === container, let overlaySize = self._view.contentLayout.overlaySize {
            let bottom: Float
            if self.overlayHidden == false && ContainerBarController.shared.hidden(.sticky) == false {
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
        self._view.contentLayout.overlayInset = inheritedInsets.bottom
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
        self.didChangeInsets()
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
        self._view.contentLayout.overlayHidden = self.screen.stickyHidden
        self.didChangeInsets()
    }

}

private extension StickyContainer {
    
    func _init() {
        self.screen.container = self
        self._contentContainer.parent = self
        self.screen.setup()
    }
    
}

extension StickyContainer : IRootContentContainer {
}

extension StickyContainer : IGroupContentContainer where ContentContainer : IGroupContentContainer {
    
    public var groupItemView: IBarItemView {
        return self.contentContainer.groupItemView
    }
    
}

extension StickyContainer : IStackContentContainer where ContentContainer : IStackContentContainer {
    
    public var stackBarView: IStackBarView {
        return self.contentContainer.stackBarView
    }
    
    public var stackBarVisibility: Float {
        return self.contentContainer.stackBarVisibility
    }
    
    public var stackBarHidden: Bool {
        return self.contentContainer.stackBarHidden
    }
    
}

extension StickyContainer : IPageContentContainer where ContentContainer : IPageContentContainer {
    
    public var pageItemView: IBarItemView {
        return self.contentContainer.pageItemView
    }
    
}

extension StickyContainer : IDialogContentContainer where ContentContainer : IDialogContentContainer {
    
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
    
    public var dialogBackgroundView: (IView & IViewAlphable)? {
        return self.contentContainer.dialogBackgroundView
    }
    
}

extension StickyContainer : IModalContentContainer where ContentContainer : IModalContentContainer {
    
    public var modalSheetInset: InsetFloat? {
        return self.contentContainer.modalSheetInset
    }
    
    public var modalSheetBackgroundView: (IView & IViewAlphable)? {
        return self.contentContainer.modalSheetBackgroundView
    }
    
}

extension StickyContainer : IHamburgerContentContainer where ContentContainer : IHamburgerContentContainer {
}

extension StickyContainer : IContainerBarControllerObserver {
    
    public func changed(containerBarController: ContainerBarController) {
        self._view.contentLayout.overlayVisibility = containerBarController.visibility(.sticky)
    }
    
}

private extension StickyContainer {
    
    class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var contentItem: LayoutItem {
            didSet { self.setNeedUpdate() }
        }
        var overlayItem: LayoutItem {
            didSet { self.setNeedUpdate() }
        }
        var overlayInset: Float {
            didSet { self.setNeedUpdate() }
        }
        var overlayVisibility: Float {
            didSet { self.setNeedUpdate() }
        }
        var overlayHidden: Bool {
            didSet { self.setNeedUpdate() }
        }
        var overlaySize: SizeFloat?
        
        init(
            contentItem: LayoutItem,
            overlayItem: LayoutItem,
            overlayInset: Float = 0,
            overlayVisibility: Float = 0,
            overlayHidden: Bool
        ) {
            self.contentItem = contentItem
            self.overlayItem = overlayItem
            self.overlayInset = overlayInset
            self.overlayVisibility = overlayVisibility
            self.overlayHidden = overlayHidden
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.contentItem.frame = bounds
            if self.overlayHidden == false {
                let overlaySize = self.overlayItem.size(available: bounds.size)
                self.overlayItem.frame = RectFloat(
                    bottomLeft: bounds.bottomLeft,
                    size: SizeFloat(
                        width: bounds.size.width,
                        height: self.overlayInset + (overlaySize.height * self.overlayVisibility)
                    )
                )
                self.overlaySize = overlaySize
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            if self.overlayHidden == false {
                return [ self.contentItem, self.overlayItem ]
            }
            return [ self.contentItem ]
        }
        
    }
    
}
