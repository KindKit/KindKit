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

extension IWidgetView {
    
    public var native: NativeView {
        return self.body.native
    }
    public var isLoaded: Bool {
        return self.body.isLoaded
    }
    public var bounds: RectFloat {
        return self.body.bounds
    }
    public var isVisible: Bool {
        return self.body.isVisible
    }
    public var isHidden: Bool {
        set(value) { self.body.isHidden = value }
        get { return self.body.isHidden }
    }
    public var layout: ILayout? {
        get { return self.body.layout }
    }
    public unowned var item: LayoutItem? {
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
    public func loadIfNeeded() {
        self.body.loadIfNeeded()
    }
    
    @inlinable
    public func size(available: SizeFloat) -> SizeFloat {
        return self.body.size(available: available)
    }
    
    @inlinable
    public func appear(to layout: ILayout) {
        self.body.appear(to: layout)
    }
    
    @inlinable
    public func disappear() {
        self.body.disappear()
    }
    
    @inlinable
    public func visible() {
        self.body.visible()
    }
    
    @inlinable
    public func visibility() {
        self.body.visibility()
    }
    
    @inlinable
    public func invisible() {
        self.body.invisible()
    }
    
    @inlinable
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self.body.hidden(value)
        return self
    }
    
    @inlinable
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self.body.onAppear(value)
        return self
    }
    
    @inlinable
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self.body.onDisappear(value)
        return self
    }
    
    @inlinable
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self.body.onVisible(value)
        return self
    }
    
    @inlinable
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self.body.onVisibility(value)
        return self
    }
    
    @inlinable
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self.body.onInvisible(value)
        return self
    }
    
}
