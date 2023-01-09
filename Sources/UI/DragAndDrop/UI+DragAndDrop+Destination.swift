//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Destination : IUIDragAndDropDestination {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
#endif
        public let onCanHandle: Signal.Args< Bool?, UI.DragAndDrop.Session > = .init()
        public let onEnter: Signal.Args< Void, UI.DragAndDrop.Session > = .init()
        public let onExit: Signal.Args< Void, UI.DragAndDrop.Session > = .init()
        public let onProposal: Signal.Args< UI.DragAndDrop.Operation?, UI.DragAndDrop.Session > = .init()
        public let onHandle: Signal.Args< Void, UI.DragAndDrop.Session > = .init()
        
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
