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
    
    @KindMonadic
    final class Source {
        
#if os(macOS)
        
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
        
        @KindMonadicSignal
        public let onItems = Signal< [NSPasteboardItem]?, Void >()
        
#elseif os(iOS)
        
        @KindMonadicSignal
        public let onItems = Signal< [NSItemProvider]?, Void >()
        
#endif
        @KindMonadicSignal
        public let onAllow = Signal< Bool?, DragAndDrop.Operation >()
        
        @KindMonadicSignal
        public let onBegin = Signal< Void, Void >()
        
        @KindMonadicSignal
        public let onEnd = Signal< Void, DragAndDrop.Operation >()
        
        @KindMonadicSignal
        public let onPreview = Signal< NativeView?, NSItemProvider >()
        
#if os(iOS)
        
        @KindMonadicSignal
        public let onPreviewParameters = Signal< UIDragPreviewParameters?, NSItemProvider >()
        
#endif
        
        @KindMonadicSignal
        public let onBeginPreview = Signal< Void, NSItemProvider >()
        
        @KindMonadicSignal
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
