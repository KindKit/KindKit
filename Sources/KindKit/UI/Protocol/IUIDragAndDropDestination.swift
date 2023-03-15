//
//  KindKit
//

import Foundation

public protocol IUIDragAndDropDestination : AnyObject {
    
    var onCanHandle: Signal.Args< Bool?, UI.DragAndDrop.Session > { get }
    
    var onEnter: Signal.Args< Void, UI.DragAndDrop.Session > { get }
    
    var onExit: Signal.Args< Void, UI.DragAndDrop.Session > { get }
    
    var onProposal: Signal.Args< UI.DragAndDrop.Operation?, UI.DragAndDrop.Session > { get }
    
    var onHandle: Signal.Args< Void, UI.DragAndDrop.Session > { get }
    
}

public extension IUIDragAndDropDestination {
    
    @inlinable
    @discardableResult
    func onCanHandle(_ closure: ((UI.DragAndDrop.Session) -> Bool?)?) -> Self {
        self.onCanHandle.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCanHandle(_ closure: @escaping (Self, UI.DragAndDrop.Session) -> Bool?) -> Self {
        self.onCanHandle.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCanHandle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Session) -> Bool?) -> Self {
        self.onCanHandle.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter(_ closure: ((UI.DragAndDrop.Session) -> Void)?) -> Self {
        self.onEnter.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter(_ closure: @escaping (Self, UI.DragAndDrop.Session) -> Void) -> Self {
        self.onEnter.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Session) -> Void) -> Self {
        self.onEnter.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit(_ closure: ((UI.DragAndDrop.Session) -> Void)?) -> Self {
        self.onExit.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit(_ closure: @escaping (Self, UI.DragAndDrop.Session) -> Void) -> Self {
        self.onExit.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Session) -> Void) -> Self {
        self.onExit.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal(_ closure: ((UI.DragAndDrop.Session) -> UI.DragAndDrop.Operation?)?) -> Self {
        self.onProposal.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal(_ closure: @escaping (Self, UI.DragAndDrop.Session) -> UI.DragAndDrop.Operation?) -> Self {
        self.onProposal.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Session) -> UI.DragAndDrop.Operation?) -> Self {
        self.onProposal.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle(_ closure: ((UI.DragAndDrop.Session) -> Void)?) -> Self {
        self.onHandle.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle(_ closure: @escaping (Self, UI.DragAndDrop.Session) -> Void) -> Self {
        self.onHandle.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Session) -> Void) -> Self {
        self.onHandle.link(sender, closure)
        return self
    }
    
}
