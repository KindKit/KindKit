//
//  KindKit
//

import Foundation

public protocol IUIViewStyleable : AnyObject {
    
    var onChangeStyle: Signal.Args< Void, Bool > { get }
    
}

public extension IUIViewStyleable where Self : IUIWidgetView, Body : IUIViewStyleable {
    
    @inlinable
    var onChangeStyle: Signal.Args< Void, Bool > {
        self.body.onChangeStyle
    }
    
}

public extension IUIViewStyleable {
    
    @inlinable
    func triggeredChangeStyle(_ userInteraction: Bool) {
        self.onChangeStyle.emit(userInteraction)
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ closure: (() -> Void)?) -> Self {
        self.onChangeStyle.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ closure: ((Self) -> Void)?) -> Self {
        self.onChangeStyle.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ closure: ((Bool) -> Void)?) -> Self {
        self.onChangeStyle.set(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle(_ closure: ((Self, Bool) -> Void)?) -> Self {
        self.onChangeStyle.set(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Void)?) -> Self {
        self.onChangeStyle.set(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onChangeStyle< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Bool) -> Void)?) -> Self {
        self.onChangeStyle.set(sender, closure)
        return self
    }
    
}
