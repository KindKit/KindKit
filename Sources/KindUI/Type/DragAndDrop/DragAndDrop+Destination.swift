//
//  KindKit
//

import KindEvent

public extension DragAndDrop {
    
    final class Destination {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
#endif
        public let onCanHandle = Signal< Bool?, DragAndDrop.Session >()
        public let onEnter = Signal< Void, DragAndDrop.Session >()
        public let onExit = Signal< Void, DragAndDrop.Session >()
        public let onProposal = Signal< DragAndDrop.Operation?, DragAndDrop.Session >()
        public let onHandle = Signal< Void, DragAndDrop.Session >()
        
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

public extension DragAndDrop.Destination {
    
    @inlinable
    @discardableResult
    func onCanHandle(_ closure: @escaping (DragAndDrop.Session) -> Bool?) -> Self {
        self.onCanHandle.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCanHandle(_ closure: @escaping (Self, DragAndDrop.Session) -> Bool?) -> Self {
        self.onCanHandle.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onCanHandle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Session) -> Bool?) -> Self {
        self.onCanHandle.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter(_ closure: @escaping (DragAndDrop.Session) -> Void) -> Self {
        self.onEnter.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter(_ closure: @escaping (Self, DragAndDrop.Session) -> Void) -> Self {
        self.onEnter.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnter< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Session) -> Void) -> Self {
        self.onEnter.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit(_ closure: @escaping (DragAndDrop.Session) -> Void) -> Self {
        self.onExit.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit(_ closure: @escaping (Self, DragAndDrop.Session) -> Void) -> Self {
        self.onExit.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onExit< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Session) -> Void) -> Self {
        self.onExit.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal(_ closure: @escaping (DragAndDrop.Session) -> DragAndDrop.Operation?) -> Self {
        self.onProposal.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal(_ closure: @escaping (Self, DragAndDrop.Session) -> DragAndDrop.Operation?) -> Self {
        self.onProposal.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onProposal< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Session) -> DragAndDrop.Operation?) -> Self {
        self.onProposal.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle(_ closure: @escaping (DragAndDrop.Session) -> Void) -> Self {
        self.onHandle.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle(_ closure: @escaping (Self, DragAndDrop.Session) -> Void) -> Self {
        self.onHandle.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onHandle< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Session) -> Void) -> Self {
        self.onHandle.add(sender, closure)
        return self
    }
    
}
