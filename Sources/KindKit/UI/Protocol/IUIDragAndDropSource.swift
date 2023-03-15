//
//  KindKit
//

import Foundation

public protocol IUIDragAndDropSource : AnyObject {
    
#if os(macOS)
    var pasteboardTypes: [NSPasteboard.PasteboardType] { get }
    
    var onItems: Signal.Empty< [NSPasteboardItem]? > { get }
#elseif os(iOS)
    var onItems: Signal.Empty< [NSItemProvider]? > { get }
#endif
    
    var onAllow: Signal.Args< Bool?, UI.DragAndDrop.Operation > { get }
    
    var onBegin: Signal.Empty< Void > { get }
    
    var onEnd: Signal.Args< Void, UI.DragAndDrop.Operation > { get }
    
    var onPreview: Signal.Args< NativeView?, NSItemProvider > { get }
    
#if os(iOS)
    
    var onPreviewParameters: Signal.Args< UIDragPreviewParameters?, NSItemProvider > { get }
    
#endif
    
    var onBeginPreview: Signal.Args< Void, NSItemProvider > { get }
    
    var onEndPreview: Signal.Args< Void, NSItemProvider > { get }
    
}

public extension IUIDragAndDropSource {
    
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
    func onAllow(_ closure: ((UI.DragAndDrop.Operation) -> Bool?)?) -> Self {
        self.onAllow.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAllow(_ closure: @escaping (Self, UI.DragAndDrop.Operation) -> Bool?) -> Self {
        self.onAllow.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onAllow< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Operation) -> Bool?) -> Self {
        self.onAllow.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: (() -> Void)?) -> Self {
        self.onBegin.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin(_ closure: @escaping (Self) -> Void) -> Self {
        self.onBegin.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBegin< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onBegin.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: ((UI.DragAndDrop.Operation) -> Void)?) -> Self {
        self.onEnd.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd(_ closure: @escaping (Self, UI.DragAndDrop.Operation) -> Void) -> Self {
        self.onEnd.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onEnd.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEnd< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, UI.DragAndDrop.Operation) -> Void) -> Self {
        self.onEnd.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview(_ closure: ((NSItemProvider) -> NativeView?)?) -> Self {
        self.onPreview.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview(_ closure: @escaping (Self, NSItemProvider) -> NativeView?) -> Self {
        self.onPreview.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> NativeView?) -> Self {
        self.onPreview.link(sender, closure)
        return self
    }
    
#if os(iOS)
    
    @inlinable
    @discardableResult
    func onPreviewParameters(_ closure: ((NSItemProvider) -> UIDragPreviewParameters?)?) -> Self {
        self.onPreviewParameters.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreviewParameters(_ closure: @escaping (Self, NSItemProvider) -> UIDragPreviewParameters?) -> Self {
        self.onPreviewParameters.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPreviewParameters< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> UIDragPreviewParameters?) -> Self {
        self.onPreviewParameters.link(sender, closure)
        return self
    }
    
#endif
    
    @inlinable
    @discardableResult
    func onBeginPreview(_ closure: ((NSItemProvider) -> Void)?) -> Self {
        self.onBeginPreview.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginPreview(_ closure: @escaping (Self, NSItemProvider) -> Void) -> Self {
        self.onBeginPreview.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onBeginPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> Void) -> Self {
        self.onBeginPreview.link(sender, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview(_ closure: ((NSItemProvider) -> Void)?) -> Self {
        self.onEndPreview.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview(_ closure: @escaping (Self, NSItemProvider) -> Void) -> Self {
        self.onEndPreview.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onEndPreview< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender, NSItemProvider) -> Void) -> Self {
        self.onEndPreview.link(sender, closure)
        return self
    }
    
}
