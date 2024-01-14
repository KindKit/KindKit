//
//  KindKit
//

import KindEvent

public protocol IViewEditable : AnyObject {
    
    var isEditing: Bool { get }
    
    var onBeginEditing: Signal< Void, Void > { get }
    
    var onEditing: Signal< Void, Void > { get }
    
    var onEndEditing: Signal< Void, Void > { get }
    
}

public extension IViewEditable where Self : IWidgetView, Body : IViewEditable {
    
    @inlinable
    var isEditing: Bool {
        self.body.isEditing
    }
    
    @inlinable
    var onBeginEditing: Signal< Void, Void > {
        self.body.onBeginEditing
    }
    
    @inlinable
    var onEditing: Signal< Void, Void > {
        self.body.onEditing
    }
    
    @inlinable
    var onEndEditing: Signal< Void, Void > {
        self.body.onEndEditing
    }
    
}

public extension IViewEditable {
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: @escaping () -> Void) -> Self {
        self.onBeginEditing.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginEditing.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginEditing.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ closure: @escaping () -> Void) -> Self {
        self.onEditing.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEditing.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEditing.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: @escaping () -> Void) -> Self {
        self.onEndEditing.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndEditing.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndEditing.add(sender, closure)
        return self
    }
    
}
