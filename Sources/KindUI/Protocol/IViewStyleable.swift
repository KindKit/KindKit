//
//  KindKit
//

import KindEvent

public protocol IViewStyleable : AnyObject {
    
    var onStyle: Signal< Void, Bool > { get }
    
}

public extension IViewStyleable where Self : IWidgetView, Body : IViewStyleable {
    
    @inlinable
    var onStyle: Signal< Void, Bool > {
        self.body.onStyle
    }
    
}

public extension IViewStyleable {
    
    @inlinable
    func triggeredChangeStyle(_ userInteraction: Bool) {
        self.onStyle.emit(userInteraction)
    }
    
}

public extension IViewStyleable {
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: @escaping () -> Void) -> Self {
        self.onStyle.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: @escaping (Self) -> Void) -> Self {
        self.onStyle.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: @escaping (Bool) -> Void) -> Self {
        self.onStyle.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle(_ closure: @escaping (Self, Bool) -> Void) -> Self {
        self.onStyle.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onStyle.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onStyle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Bool) -> Void) -> Self {
        self.onStyle.add(sender, closure)
        return self
    }
    
}
