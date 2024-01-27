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

extension DragAndDrop {
    
    @Monadic
    public final class Destination {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
#endif
        @MonadicSignal
        public let onCanHandle = Signal< Bool?, DragAndDrop.Session >()
        
        @MonadicSignal
        public let onEnter = Signal< Void, DragAndDrop.Session >()
        
        @MonadicSignal
        public let onExit = Signal< Void, DragAndDrop.Session >()
        
        @MonadicSignal
        public let onProposal = Signal< DragAndDrop.Operation?, DragAndDrop.Session >()
        
        @MonadicSignal
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
