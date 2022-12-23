//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Source : IUIDragAndDropSource {
        
        public let onItems: Signal.Empty< [NSItemProvider]? > = .init()
        public let onAllow: Signal.Args< Bool?, UI.DragAndDrop.Operation > = .init()
        public let onBegin: Signal.Empty< Void > = .init()
        public let onEnd: Signal.Args< Void, UI.DragAndDrop.Operation > = .init()
        public let onPreview: Signal.Args< NativeView?, NSItemProvider > = .init()
#if os(iOS)
        public let onPreviewParameters: Signal.Args< UIDragPreviewParameters?, NSItemProvider > = .init()
#endif
        public let onBeginPreview: Signal.Args< Void, NSItemProvider > = .init()
        public let onEndPreview: Signal.Args< Void, NSItemProvider > = .init()
        
        public init() {
        }
        
    }
    
}
