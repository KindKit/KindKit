//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Source : IUIDragAndDropSource {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
        public let onItems: Signal.Empty< [NSPasteboardItem]? > = .init()
#elseif os(iOS)
        public let onItems: Signal.Empty< [NSItemProvider]? > = .init()
#endif
        public let onAllow: Signal.Args< Bool?, UI.DragAndDrop.Operation > = .init()
        public let onBegin = Signal.Empty< Void >()
        public let onEnd: Signal.Args< Void, UI.DragAndDrop.Operation > = .init()
        public let onPreview = Signal.Args< NativeView?, NSItemProvider >()
#if os(iOS)
        public let onPreviewParameters = Signal.Args< UIDragPreviewParameters?, NSItemProvider >()
#endif
        public let onBeginPreview = Signal.Args< Void, NSItemProvider >()
        public let onEndPreview = Signal.Args< Void, NSItemProvider >()
        
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
