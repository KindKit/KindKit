//
//  KindKit
//

import KindEvent
import KindMath

public protocol IViewHitable : AnyObject {
    
    var onHit: Signal< Bool?, Point > { get }
    
}

public extension IViewHitable where Self : IWidgetView, Body : IViewHitable {
    
    @inlinable
    var onHit: Signal< Bool?, Point > {
        self.body.onHit
    }
    
}

public extension IViewHitable {
    
    @inlinable
    @discardableResult
    func onHit(_ closure: @escaping () -> Bool?) -> Self {
        self.onHit.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: @escaping (Self) -> Bool?) -> Self {
        self.onHit.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: @escaping (Point) -> Bool?) -> Self {
        self.onHit.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit(_ closure: @escaping (Self, Point) -> Bool?) -> Self {
        self.onHit.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Bool?) -> Self {
        self.onHit.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHit< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, Point) -> Bool?) -> Self {
        self.onHit.add(sender, closure)
        return self
    }
    
}
