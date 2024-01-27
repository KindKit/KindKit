//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindEvent
import KindMonadicMacro

public extension DragAndDrop {
    
    @Monadic
    final class Source {
        
#if os(macOS)
        
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
        
        @MonadicSignal
        public let onItems = Signal< [NSPasteboardItem]?, Void >()
        
#elseif os(iOS)
        
        @MonadicSignal
        public let onItems = Signal< [NSItemProvider]?, Void >()
        
#endif
        @MonadicSignal
        public let onAllow = Signal< Bool?, DragAndDrop.Operation >()
        
        @MonadicSignal
        public let onBegin = Signal< Void, Void >()
        
        @MonadicSignal
        public let onEnd = Signal< Void, DragAndDrop.Operation >()
        
        @MonadicSignal
        public let onPreview = Signal< NativeView?, NSItemProvider >()
        
#if os(iOS)
        
        @MonadicSignal
        public let onPreviewParameters = Signal< UIDragPreviewParameters?, NSItemProvider >()
        
#endif
        
        @MonadicSignal
        public let onBeginPreview = Signal< Void, NSItemProvider >()
        
        @MonadicSignal
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
