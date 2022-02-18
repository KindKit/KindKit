//
//  KindKitView
//

import Foundation
#if os(iOS)
import UIKit
#endif
import KindKitCore
import KindKitMath

public class RootContainer : IRootContainer {
    
    public unowned var delegate: IRootContainerDelegate?
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
    public var statusBarView: IStatusBarView? {
        didSet(oldValue) {
            guard self.statusBarView !== oldValue else { return }
            self._view.contentLayout.statusBarItem = self.statusBarView.flatMap({ LayoutItem(view: $0) })
        }
    }
    public var safeArea: InsetFloat {
        didSet(oldValue) {
            guard self.safeArea != oldValue else { return }
            self.didChangeInsets()
        }
    }
    public var overlayContainer: IRootContentContainer? {
        didSet(oldValue) {
            guard self.overlayContainer !== oldValue else { return }
            if let overlayContainer = self.overlayContainer {
                if self.isPresented == true {
                    overlayContainer.prepareHide(interactive: false)
                    overlayContainer.finishHide(interactive: false)
                }
                overlayContainer.parent = nil
            }
            self._view.contentLayout.overlayItem = self.overlayContainer.flatMap({ LayoutItem(view: $0.view) })
            if let overlayContainer = self.overlayContainer {
                overlayContainer.parent = self
                if self.isPresented == true {
                    overlayContainer.prepareShow(interactive: false)
                    overlayContainer.finishShow(interactive: false)
                }
            }
        }
    }
    public var contentContainer: IRootContentContainer {
        didSet(oldValue) {
            guard self.contentContainer !== oldValue else { return }
            if self.isPresented == true {
                self.contentContainer.prepareHide(interactive: false)
                self.contentContainer.finishHide(interactive: false)
            }
            self.contentContainer.parent = nil
            self._view.contentLayout.contentItem = LayoutItem(view: self.contentContainer.view)
            self.contentContainer.parent = self
            if self.isPresented == true {
                self.contentContainer.prepareShow(interactive: false)
                self.contentContainer.finishShow(interactive: false)
            }
        }
    }
    
    private var _view: CustomView< Layout >
    
    public init(
        statusBarView: IStatusBarView? = nil,
        overlayContainer: IRootContentContainer?,
        contentContainer: IRootContentContainer
    ) {
        self.isPresented = false
        self.statusBarView = statusBarView
        self.overlayContainer = overlayContainer
        self.contentContainer = contentContainer
        self.safeArea = .zero
        self._view = CustomView(
            contentLayout: Layout(
                statusBarItem: statusBarView.flatMap({ LayoutItem(view: $0) }),
                overlayItem: self.overlayContainer.flatMap({ LayoutItem(view: $0.view) }),
                contentItem: LayoutItem(view: contentContainer.view)
            )
        )
        self._init()
    }
    
    #if os(iOS)
    
    public func setNeedUpdateStatusBar() {
        self.delegate?.updateStatusBar()
    }
    
    public func setNeedUpdateOrientations() {
        self.delegate?.updateOrientations()
    }
    
    #endif
    
    public func insets(of container: IContainer, interactive: Bool) -> InsetFloat {
        if self.overlayContainer === container {
            return self.safeArea
        } else if self.contentContainer === container {
            return self.safeArea
        }
        return .zero
    }
    
    public func didChangeInsets() {
        self.overlayContainer?.didChangeInsets()
        self.contentContainer.didChangeInsets()
    }
    
    public func activate() -> Bool {
        if let overlayContainer = self.overlayContainer {
            if overlayContainer.activate() == true {
                return true
            }
        }
        return self.contentContainer.activate()
    }
    
    public func didChangeAppearance() {
        if let overlayContainer = self.overlayContainer {
            overlayContainer.didChangeAppearance()
        }
        self.contentContainer.didChangeAppearance()
    }
    
    public func prepareShow(interactive: Bool) {
        self.didChangeInsets()
        self.overlayContainer?.prepareShow(interactive: interactive)
        self.contentContainer.prepareShow(interactive: interactive)
    }
    
    public func finishShow(interactive: Bool) {
        self.isPresented = true
        self.overlayContainer?.finishShow(interactive: interactive)
        self.contentContainer.finishShow(interactive: interactive)
    }
    
    public func cancelShow(interactive: Bool) {
        self.overlayContainer?.cancelShow(interactive: interactive)
        self.contentContainer.cancelShow(interactive: interactive)
    }
    
    public func prepareHide(interactive: Bool) {
        self.overlayContainer?.prepareHide(interactive: interactive)
        self.contentContainer.prepareHide(interactive: interactive)
    }
    
    public func finishHide(interactive: Bool) {
        self.isPresented = false
        self.overlayContainer?.finishHide(interactive: interactive)
        self.contentContainer.finishHide(interactive: interactive)
    }
    
    public func cancelHide(interactive: Bool) {
        self.overlayContainer?.cancelHide(interactive: interactive)
        self.contentContainer.cancelHide(interactive: interactive)
    }

}

private extension RootContainer {
    
    func _init() {
        self.overlayContainer?.parent = self
        self.contentContainer.parent = self
    }
    
}

private extension RootContainer {
    
    class Layout : ILayout {
        
        unowned var delegate: ILayoutDelegate?
        unowned var view: IView?
        var statusBarItem: LayoutItem? {
            didSet { self.setNeedUpdate() }
        }
        var overlayItem: LayoutItem? {
            didSet { self.setNeedUpdate() }
        }
        var contentItem: LayoutItem {
            didSet { self.setNeedUpdate() }
        }
        
        init(
            statusBarItem: LayoutItem?,
            overlayItem: LayoutItem?,
            contentItem: LayoutItem
        ) {
            self.statusBarItem = statusBarItem
            self.overlayItem = overlayItem
            self.contentItem = contentItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let overlayItem = self.overlayItem {
                overlayItem.frame = bounds
            }
            if let statusBarItem = self.statusBarItem {
                let statusBarSize = statusBarItem.size(available: SizeFloat(width: bounds.size.width, height: .infinity))
                statusBarItem.frame = RectFloat(
                    x: bounds.origin.x,
                    y: bounds.origin.y,
                    width: statusBarSize.width,
                    height: statusBarSize.height
                )
            }
            self.contentItem.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [LayoutItem] {
            var items = [
                self.contentItem
            ]
            if let statusBarItem = self.statusBarItem {
                items.append(statusBarItem)
            }
            if let overlayItem = self.overlayItem {
                items.append(overlayItem)
            }
            return items
        }
        
    }
    
}
