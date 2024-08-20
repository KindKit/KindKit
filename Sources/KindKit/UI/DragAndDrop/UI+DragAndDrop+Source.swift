//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Source {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
        public let onItems = Signal.Empty< [NSPasteboardItem]? >()
#elseif os(iOS)
        public let onItems = Signal.Args< [NSItemProvider]?, UI.DragAndDrop.DragSession >()
#endif
        public let onAllow = Signal.Args< Bool?, UI.DragAndDrop.DragOperation >()
        public let onBegin = Signal.Args< Void, UI.DragAndDrop.DragSession >()
        public let onEnd = Signal.Args< Void, UI.DragAndDrop.DragOperation >()
#if os(iOS)
        public let onPreview = Signal.Args< UITargetedDragPreview?, UI.DragAndDrop.DragItem >()
#endif
        public let onBeginPreview = Signal.Args< Void, UI.DragAndDrop.DragItem >()
        public let onEndPreview = Signal.Args< Void, UI.DragAndDrop.DragItem >()
        
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

public extension UI.DragAndDrop.Source {
    
#if os(macOS)
    
    @inlinable
    @discardableResult
    func onItems(_ closure: (() -> [NSPasteboardItem]?)?) -> Self {
        self.onItems.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems(_ closure: ((Self) -> [NSPasteboardItem]?)?) -> Self {
        self.onItems.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> [NSPasteboardItem]?)?) -> Self {
        self.onItems.link(sender, closure)
        return self
    }
    
#elseif os(iOS)
    
    @inlinable
    @discardableResult
    func onItems(_ closure: (() -> [NSItemProvider]?)?) -> Self {
        self.onItems.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems(_ closure: ((Self) -> [NSItemProvider]?)?) -> Self {
        self.onItems.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems< Sender : AnyObject >(_ sender: Sender, _ closure: ((Sender) -> [NSItemProvider]?)?) -> Self {
        self.onItems.link(sender, closure)
        return self
    }
    
#endif
    
    @inlinable
    @discardableResult
    func onAllow(_ closure: ((UI.DragAndDrop.DragOperation) -> Bool?)?) -> Self {
        self.onAllow.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAllow(_ closure: @escaping (Self, UI.DragAndDrop.DragOperation) -> Bool?) -> Self {
        self.onAllow.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAllow< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DragOperation) -> Bool?) -> Self {
        self.onAllow.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: ((UI.DragAndDrop.DragSession) -> Void)?) -> Self {
        self.onBegin.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping (Self, UI.DragAndDrop.DragSession) -> Void) -> Self {
        self.onBegin.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DragSession) -> Void) -> Self {
        self.onBegin.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: ((UI.DragAndDrop.DragOperation) -> Void)?) -> Self {
        self.onEnd.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping (Self, UI.DragAndDrop.DragOperation) -> Void) -> Self {
        self.onEnd.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DragOperation) -> Void) -> Self {
        self.onEnd.link(sender, closure)
        return self
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func onPreview(_ closure: ((UI.DragAndDrop.DragItem) -> UITargetedDragPreview?)?) -> Self {
        self.onPreview.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview(_ closure: @escaping (Self, UI.DragAndDrop.DragItem) -> UITargetedDragPreview?) -> Self {
        self.onPreview.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DragItem) -> UITargetedDragPreview?) -> Self {
        self.onPreview.link(sender, closure)
        return self
    }
    
#endif
    
    @inlinable
    @discardableResult
    func onBeginPreview(_ closure: ((UI.DragAndDrop.DragItem) -> Void)?) -> Self {
        self.onBeginPreview.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginPreview(_ closure: @escaping (Self, UI.DragAndDrop.DragItem) -> Void) -> Self {
        self.onBeginPreview.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DragItem) -> Void) -> Self {
        self.onBeginPreview.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview(_ closure: ((UI.DragAndDrop.DragItem) -> Void)?) -> Self {
        self.onEndPreview.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview(_ closure: @escaping (Self, UI.DragAndDrop.DragItem) -> Void) -> Self {
        self.onEndPreview.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.DragItem) -> Void) -> Self {
        self.onEndPreview.link(sender, closure)
        return self
    }
    
}
