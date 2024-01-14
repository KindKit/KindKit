//
//  KindKit
//

import KindEvent
import KindMath

public protocol IWidgetView : IView {
    
    associatedtype Body : IView
    
    var body: Body { get }

}

public extension IWidgetView {
    
    @inlinable
    var appearedLayout: ILayout? {
        self.body.appearedLayout
    }
    
    @inlinable
    var native: NativeView {
        return self.body.native
    }
    
    @inlinable
    var isLoaded: Bool {
        return self.body.isLoaded
    }
    
    @inlinable
    var bounds: Rect {
        return self.body.bounds
    }
    
    @inlinable
    var frame: Rect {
        set { self.body.frame = newValue }
        get { self.body.frame }
    }
    
    @inlinable
    var isVisible: Bool {
        return self.body.isVisible
    }
    
    @inlinable
    var isHidden: Bool {
        set { self.body.isHidden = newValue }
        get { self.body.isHidden }
    }
    
    @inlinable
    var onAppear: Signal< Void, Void > {
        self.body.onAppear
    }
    
    @inlinable
    var onDisappear: Signal< Void, Void > {
        self.body.onDisappear
    }
    
    @inlinable
    var onVisible: Signal< Void, Void > {
        self.body.onVisible
    }
    
    @inlinable
    var onInvisible: Signal< Void, Void > {
        self.body.onInvisible
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
    func size(available: Size) -> Size {
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
    func invisible() {
        self.body.invisible()
    }
    
}
