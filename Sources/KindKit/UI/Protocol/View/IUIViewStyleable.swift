//
//  KindKit
//

import Foundation

public protocol IUIViewStyleable : AnyObject {
    
    var onStyle: Signal.Args< Void, Bool > { get }
    
}

public extension IUIViewStyleable where Self : IUIWidgetView, Body : IUIViewStyleable {
    
    @inlinable
    var onStyle: Signal.Args< Void, Bool > {
        self.body.onStyle
    }
    
}

public extension IUIViewStyleable {
    
    @inlinable
    func triggeredChangeStyle(_ userInteraction: Bool) {
        self.onStyle.emit(userInteraction)
    }
    
}

public extension IUIViewStyleable {
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: (() -> Void)?) -> Self {
        self.onStyle.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: @escaping (Self) -> Void) -> Self {
        self.onStyle.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: ((Bool) -> Void)?) -> Self {
        self.onStyle.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onStyle.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onStyle.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onStyle.link(sender, closure)
        return self
    }
    
}
