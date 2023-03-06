//
//  KindKit
//

import Foundation

public protocol IUIViewHitable : AnyObject {
    
    var onHit: Signal.Args< Bool?, Point > { get }
    
}

public extension IUIViewHitable where Self : IUIWidgetView, Body : IUIViewHitable {
    
    @inlinable
    var onHit: Signal.Args< Bool?, Point > {
        self.body.onHit
    }
    
}

public extension IUIViewHitable {
    
    @inlinable
    @discardableResult
    func onHit(_ closure: (() -> Bool?)?) -> Self {
        self.onHit.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: ((Self) -> Bool?)?) -> Self {
        self.onHit.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: ((Point) -> Bool?)?) -> Self {
        self.onHit.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: ((Self, Point) -> Bool?)?) -> Self {
        self.onHit.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> Bool?)?) -> Self {
        self.onHit.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, Point) -> Bool?)?) -> Self {
        self.onHit.link(sender, closure)
        return self
    }
    
}
