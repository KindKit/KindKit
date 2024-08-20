//
//  KindKit
//

public extension UI.DragAndDrop {
    
    struct DragOperation {
        
        public let session: UI.DragAndDrop.DragSession
        public let operation: UI.DragAndDrop.Operation
        
        init(
            _ session: UI.DragAndDrop.DragSession,
            _ operation: UI.DragAndDrop.Operation
        ) {
            self.session = session
            self.operation = operation
        }
        
    }
    
}
