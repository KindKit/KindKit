//
//  KindKit
//

import Foundation

public protocol IUIViewHitable : AnyObject {
    
    var onHit: Signal.Args< Bool?, PointFloat > { get }
    
}

public extension IUIViewHitable where Self : IUIWidgetView, Body : IUIViewHitable {
    
    @inlinable
    var onHit: Signal.Args< Bool?, PointFloat > {
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
    func onHit(_ closure: ((PointFloat) -> Bool?)?) -> Self {
        self.onHit.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: ((Self, PointFloat) -> Bool?)?) -> Self {
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
    func onHit< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender, PointFloat) -> Bool?)?) -> Self {
        self.onHit.link(sender, closure)
        return self
    }
    
}
