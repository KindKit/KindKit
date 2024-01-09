//
//  KindKit
//

import Foundation

public protocol IUIWidgetView : IUIView {
    
    associatedtype Body : IUIView
    
    var body: Body { get }

}

public extension IUIWidgetView {
    
    @inlinable
    var appearedLayout: IUILayout? {
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
    var onAppear: Signal.Empty< Void > {
        self.body.onAppear
    }
    
    @inlinable
    var onDisappear: Signal.Empty< Void > {
        self.body.onDisappear
    }
    
    @inlinable
    var onVisible: Signal.Empty< Void > {
        self.body.onVisible
    }
    
    @inlinable
    var onInvisible: Signal.Empty< Void > {
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
    func appear(to layout: IUILayout) {
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
