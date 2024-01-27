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
    
    @KindMonadic
    public final class Destination {
        
#if os(macOS)
        public let pasteboardTypes: [NSPasteboard.PasteboardType]
#endif
        @KindMonadicSignal
        public let onCanHandle = Signal< Bool?, DragAndDrop.Session >()
        
        @KindMonadicSignal
        public let onEnter = Signal< Void, DragAndDrop.Session >()
        
        @KindMonadicSignal
        public let onExit = Signal< Void, DragAndDrop.Session >()
        
        @KindMonadicSignal
        public let onProposal = Signal< DragAndDrop.Operation?, DragAndDrop.Session >()
        
        @KindMonadicSignal
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
