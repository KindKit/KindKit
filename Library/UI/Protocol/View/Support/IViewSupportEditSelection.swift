//
//  KindKit
//

import KindEvent
import KindGraphics

public protocol IViewSupportEditSelection : AnyObject {
    
    var selectionRange: Range< Int >? { set get }
    
    var selectionColor: Color { set get }
    
    var onSelectionRange: Signal< Void, Void > { get }
    
}

public extension IViewSupportEditSelection {
    
    @inlinable
    @discardableResult
    func selectionRange(_ value: Range< Int >?) -> Self {
        self.selectionRange = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectionRange(on: () -> Range< Int >?) -> Self {
        self.selectionRange = on()
        return self
    }

    @inlinable
    @discardableResult
    func selectionRange(on: (Self) -> Range< Int >?) -> Self {
        self.selectionRange = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func selectionColor(_ value: Color) -> Self {
        self.selectionColor = value
        return self
    }
    
    @inlinable
    @discardableResult
    func selectionColor(on: () -> Color) -> Self {
        self.selectionColor = on()
        return self
    }

    @inlinable
    @discardableResult
    func selectionColor(on: (Self) -> Color) -> Self {
        self.selectionColor = on(self)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelectionRange(_ closure: @escaping () -> Void) -> Self {
        self.onSelectionRange.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelectionRange(_ closure: @escaping (Self) -> Void) -> Self {
        self.onSelectionRange.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelectionRange< Target : AnyObject >(_ target: Target, _ closure: @escaping (Target) -> Void) -> Self {
        self.onSelectionRange.add(target, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onSelectionRange(remove target: AnyObject) -> Self {
        self.onSelectionRange.remove(target)
        return self
    }
    
}

public extension IViewSupportEditSelection where Self : CompositorTrait, Body : IViewSupportEditSelection {
    
    @inlinable
    var selectionRange: Range< Int >? {
        set { self.body.selectionRange = newValue }
        get { self.body.selectionRange }
    }
    
    @inlinable
    var selectionColor: Color {
        set { self.body.selectionColor = newValue }
        get { self.body.selectionColor }
    }
    
    @inlinable
    var onSelectionRange: Signal< Void, Void > {
        self.body.onSelectionRange
    }
    
}
