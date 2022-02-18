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
    
    public func loadIfNeeded() {
        self.body.loadIfNeeded()
    }
    
    public func size(available: SizeFloat) -> SizeFloat {
        return self.body.size(available: available)
    }
    
    public func appear(to layout: ILayout) {
        self.body.appear(to: layout)
    }
    
    public func disappear() {
        self.body.disappear()
    }
    
    public func visible() {
        self.body.visible()
    }
    
    public func visibility() {
        self.body.visibility()
    }
    
    public func invisible() {
        self.body.invisible()
    }
    
    @discardableResult
    public func hidden(_ value: Bool) -> Self {
        self.body.hidden(value)
        return self
    }
    
    @discardableResult
    public func onAppear(_ value: (() -> Void)?) -> Self {
        self.body.onAppear(value)
        return self
    }
    
    @discardableResult
    public func onDisappear(_ value: (() -> Void)?) -> Self {
        self.body.onDisappear(value)
        return self
    }
    
    @discardableResult
    public func onVisible(_ value: (() -> Void)?) -> Self {
        self.body.onVisible(value)
        return self
    }
    
    @discardableResult
    public func onVisibility(_ value: (() -> Void)?) -> Self {
        self.body.onVisibility(value)
        return self
    }
    
    @discardableResult
    public func onInvisible(_ value: (() -> Void)?) -> Self {
        self.body.onInvisible(value)
        return self
    }
    
}
