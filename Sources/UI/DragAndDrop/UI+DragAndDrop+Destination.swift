//
//  KindKit
//

import Foundation

public extension UI.DragAndDrop {
    
    final class Destination : IUIDragAndDropDestination {
        
        public let onCanHandle: Signal.Args< Bool?, UI.DragAndDrop.Session > = .init()
        public let onEnter: Signal.Args< Void, UI.DragAndDrop.Session > = .init()
        public let onExit: Signal.Args< Void, UI.DragAndDrop.Session > = .init()
        public let onProposal: Signal.Args< UI.DragAndDrop.Operation?, UI.DragAndDrop.Session > = .init()
        public let onHandle: Signal.Args< Void, UI.DragAndDrop.Session > = .init()
        
        public init() {
        }
        
    }
    
}
