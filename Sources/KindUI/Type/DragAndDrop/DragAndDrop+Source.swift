//
//  KindKit
//

import KindEvent

public extension DragAndDrop {
    
    final class Source {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
        public let onItems = Signal< [NSPasteboardItem]?, Void >()
#elseif os(iOS)
        public let onItems = Signal< [NSItemProvider]?, Void >()
#endif
        public let onAllow = Signal< Bool?, DragAndDrop.Operation >()
        public let onBegin = Signal< Void, Void >()
        public let onEnd = Signal< Void, DragAndDrop.Operation >()
        public let onPreview = Signal< NativeView?, NSItemProvider >()
#if os(iOS)
        public let onPreviewParameters = Signal< UIDragPreviewParameters?, NSItemProvider >()
#endif
        public let onBeginPreview = Signal< Void, NSItemProvider >()
        public let onEndPreview = Signal< Void, NSItemProvider >()
        
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

public extension DragAndDrop.Source {
    
#if os(macOS)
    
    @inlinable
    @discardableResult
    func onItems(_ closure: @escaping () -> [NSPasteboardItem]?) -> Self {
        self.onItems.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems(_ closure: @escaping (Self) -> [NSPasteboardItem]?) -> Self {
        self.onItems.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> [NSPasteboardItem]?) -> Self {
        self.onItems.add(sender, closure)
        return self
    }
    
#elseif os(iOS)
    
    @inlinable
    @discardableResult
    func onItems(_ closure: @escaping () -> [NSItemProvider]?) -> Self {
        self.onItems.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems(_ closure: @escaping (Self) -> [NSItemProvider]?) -> Self {
        self.onItems.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onItems< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> [NSItemProvider]?) -> Self {
        self.onItems.add(sender, closure)
        return self
    }
    
#endif
    
    @inlinable
    @discardableResult
    func onAllow(_ closure: @escaping (DragAndDrop.Operation) -> Bool?) -> Self {
        self.onAllow.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAllow(_ closure: @escaping (Self, DragAndDrop.Operation) -> Bool?) -> Self {
        self.onAllow.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAllow< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Operation) -> Bool?) -> Self {
        self.onAllow.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping () -> Void) -> Self {
        self.onBegin.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBegin.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBegin.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping (DragAndDrop.Operation) -> Void) -> Self {
        self.onEnd.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping (Self, DragAndDrop.Operation) -> Void) -> Self {
        self.onEnd.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEnd.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, DragAndDrop.Operation) -> Void) -> Self {
        self.onEnd.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview(_ closure: @escaping (NSItemProvider) -> NativeView?) -> Self {
        self.onPreview.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview(_ closure: @escaping (Self, NSItemProvider) -> NativeView?) -> Self {
        self.onPreview.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> NativeView?) -> Self {
        self.onPreview.add(sender, closure)
        return self
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func onPreviewParameters(_ closure: @escaping (NSItemProvider) -> UIDragPreviewParameters?) -> Self {
        self.onPreviewParameters.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreviewParameters(_ closure: @escaping (Self, NSItemProvider) -> UIDragPreviewParameters?) -> Self {
        self.onPreviewParameters.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreviewParameters< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> UIDragPreviewParameters?) -> Self {
        self.onPreviewParameters.add(sender, closure)
        return self
    }
    
#endif
    
    @inlinable
    @discardableResult
    func onBeginPreview(_ closure: @escaping (NSItemProvider) -> Void) -> Self {
        self.onBeginPreview.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginPreview(_ closure: @escaping (Self, NSItemProvider) -> Void) -> Self {
        self.onBeginPreview.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> Void) -> Self {
        self.onBeginPreview.add(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview(_ closure: @escaping (NSItemProvider) -> Void) -> Self {
        self.onEndPreview.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview(_ closure: @escaping (Self, NSItemProvider) -> Void) -> Self {
        self.onEndPreview.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> Void) -> Self {
        self.onEndPreview.add(sender, closure)
        return self
    }
    
}

