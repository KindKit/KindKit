//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public protocol IWidgetView : IView {
    
    associatedtype Body : IView
    
    var body: Body { get }

}

public extension IWidgetView {
    
    @inlinable
    var native: NativeView {
        return self.body.native
    }
    
    @inlinable
    var isLoaded: Bool {
        return self.body.isLoaded
    }
    
    @inlinable
    var bounds: RectFloat {
        return self.body.bounds
    }
    
    @inlinable
    var isVisible: Bool {
        return self.body.isVisible
    }
    
    @inlinable
    var isHidden: Bool {
        set(value) { self.body.isHidden = value }
        get { return self.body.isHidden }
    }
    
    @inlinable
    var layout: ILayout? {
        get { return self.body.layout }
    }
    
    @inlinable
    unowned var item: LayoutItem? {
        set(value) { self.body.item = value }
        get { return self.body.item }
    }
    
    @inlinable
    func setNeedForceLayout() {
        self.body.setNeedForceLayout()
    }
    
    @inlinable
    func setNeedLayout() {
        self.body.setNeedLayout()
    }
    
    @inlinable
    func loadIfNeeded() {
        self.body.loadIfNeeded()
    }
    
    @inlinable
    func size(available: SizeFloat) -> SizeFloat {
        return self.body.size(available: available)
    }
    
    @inlinable
    func appear(to layout: ILayout) {
        self.body.appear(to: layout)
    }
    
    @inlinable
    func disappear() {
        self.body.disappear()
    }
    
    @inlinable
    func visible() {
        self.body.visible()
    }
    
    @inlinable
    func visibility() {
        self.body.visibility()
    }
    
    @inlinable
    func invisible() {
        self.body.invisible()
    }
    
    @inlinable
    @discardableResult
    func hidden(_ value: Bool) -> Self {
        self.body.hidden(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAppear(_ value: (() -> Void)?) -> Self {
        self.body.onAppear(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: (() -> Void)?) -> Self {
        self.body.onDisappear(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: (() -> Void)?) -> Self {
        self.body.onVisible(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: (() -> Void)?) -> Self {
        self.body.onVisibility(value)
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: (() -> Void)?) -> Self {
        self.body.onInvisible(value)
        return self
    }
    
}
