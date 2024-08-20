//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Destination {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
#endif
        public let onCanHandle = Signal.Args< Bool?, UI.DragAndDrop.DropSession >()
        public let onEnter = Signal.Args< Void, UI.DragAndDrop.DropSession >()
        public let onExit = Signal.Args< Void, UI.DragAndDrop.DropSession >()
        public let onProposal = Signal.Args< UI.DragAndDrop.Operation?, UI.DragAndDrop.DropSession >()
        public let onHandle = Signal.Args< Void, UI.DragAndDrop.DropSession >()
        
#if os(macOS)
        
        public init(_ types: [NSPasteboard.PasteboardType]) {
            self.pasteboardTypes = types
        }
        
#elseif os(iOS)
        
        public init() {
        }
        
#endif
        
    }
    
}

public extension UI.DragAndDrop.Destination {
    
    @inlinable
    @discardableResult
    func onCanHandle(_ closure: ((UI.DragAndDrop.DropSession) -> Bool?)?) -> Self {
        self.onCanHandle.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCanHandle(_ closure: @escaping (Self, UI.DragAndDrop.DropSession) -> Bool?) -> Self {
        self.onCanHandle.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCanHandle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DropSession) -> Bool?) -> Self {
        self.onCanHandle.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter(_ closure: ((UI.DragAndDrop.DropSession) -> Void)?) -> Self {
        self.onEnter.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter(_ closure: @escaping (Self, UI.DragAndDrop.DropSession) -> Void) -> Self {
        self.onEnter.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DropSession) -> Void) -> Self {
        self.onEnter.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit(_ closure: ((UI.DragAndDrop.DropSession) -> Void)?) -> Self {
        self.onExit.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit(_ closure: @escaping (Self, UI.DragAndDrop.DropSession) -> Void) -> Self {
        self.onExit.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DropSession) -> Void) -> Self {
        self.onExit.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal(_ closure: ((UI.DragAndDrop.DropSession) -> UI.DragAndDrop.Operation?)?) -> Self {
        self.onProposal.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal(_ closure: @escaping (Self, UI.DragAndDrop.DropSession) -> UI.DragAndDrop.Operation?) -> Self {
        self.onProposal.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DropSession) -> UI.DragAndDrop.Operation?) -> Self {
        self.onProposal.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle(_ closure: ((UI.DragAndDrop.DropSession) -> Void)?) -> Self {
        self.onHandle.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle(_ closure: @escaping (Self, UI.DragAndDrop.DropSession) -> Void) -> Self {
        self.onHandle.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DropSession) -> Void) -> Self {
        self.onHandle.link(sender, closure)
        return self
    }
    
}
