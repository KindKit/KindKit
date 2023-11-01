//
//  KindKit
//

import Foundation

public protocol IUIViewEditable : AnyObject {
    
    var isEditing: Bool { get }
    
    var onBeginEditing: Signal.Empty< Void > { get }
    
    var onEditing: Signal.Empty< Void > { get }
    
    var onEndEditing: Signal.Empty< Void > { get }
    
}

public extension IUIViewEditable where Self : IUIWidgetView, Body : IUIViewEditable {
    
    @inlinable
    var isEditing: Bool {
        self.body.isEditing
    }
    
    @inlinable
    var onBeginEditing: Signal.Empty< Void > {
        self.body.onBeginEditing
    }
    
    @inlinable
    var onEditing: Signal.Empty< Void > {
        self.body.onEditing
    }
    
    @inlinable
    var onEndEditing: Signal.Empty< Void > {
        self.body.onEndEditing
    }
    
}

public extension IUIViewEditable {
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: (() -> Void)?) -> Self {
        self.onBeginEditing.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBeginEditing.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginEditing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBeginEditing.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ closure: (() -> Void)?) -> Self {
        self.onEditing.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEditing.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEditing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEditing.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: (() -> Void)?) -> Self {
        self.onEndEditing.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing(_ closure: @escaping (Self) -> Void) -> Self {
        self.onEndEditing.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndEditing< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEndEditing.link(sender, closure)
        return self
    }
    
}
