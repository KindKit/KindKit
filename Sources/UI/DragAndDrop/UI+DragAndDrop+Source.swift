//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Source : IUIDragAndDropSource {
        
        public var onItems: Signal.Empty< [NSItemProvider]? > = .init()
        public var onAllow: Signal.Args< Bool?, UI.DragAndDrop.Operation > = .init()
        public var onBegin: Signal.Empty< Void > = .init()
        public var onEnd: Signal.Args< Void, UI.DragAndDrop.Operation > = .init()
        public var onPreview: Signal.Args< NativeView?, NSItemProvider > = .init()
        public var onBeginPreview: Signal.Args< Void, NSItemProvider > = .init()
        public var onEndPreview: Signal.Args< Void, NSItemProvider > = .init()
        
        public init() {
        }
        
    }
    
}
