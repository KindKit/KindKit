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
    var layout: IUILayout? {
        get { return self.body.layout }
    }
    
    @inlinable
    unowned var item: UI.Layout.Item? {
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
    func onAppear(_ value: ((Self) -> Void)?) -> Self {
        if let value = value {
            self.body.onAppear({ [unowned self] _ in value(self) })
        } else {
            self.body.onAppear(nil)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func onDisappear(_ value: ((Self) -> Void)?) -> Self {
        if let value = value {
            self.body.onDisappear({ [unowned self] _ in value(self) })
        } else {
            self.body.onDisappear(nil)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisible(_ value: ((Self) -> Void)?) -> Self {
        if let value = value {
            self.body.onVisible({ [unowned self] _ in value(self) })
        } else {
            self.body.onVisible(nil)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func onVisibility(_ value: ((Self) -> Void)?) -> Self {
        if let value = value {
            self.body.onVisibility({ [unowned self] _ in value(self) })
        } else {
            self.body.onVisibility(nil)
        }
        return self
    }
    
    @inlinable
    @discardableResult
    func onInvisible(_ value: ((Self) -> Void)?) -> Self {
        if let value = value {
            self.body.onInvisible({ [unowned self] _ in value(self) })
        } else {
            self.body.onInvisible(nil)
        }
        return self
    }
    
}
