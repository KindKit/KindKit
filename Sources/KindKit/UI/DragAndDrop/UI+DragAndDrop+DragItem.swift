//
//  KindKit
//

public extension UI.DragAndDrop {
    
    struct DragItem {
        
        public let session: UI.DragAndDrop.DragSession
        public let item: UIDragItem
        
        init(
            _ session: UI.DragAndDrop.DragSession,
            _ item: UIDragItem
        ) {
            self.session = session
            self.item = item
        }
        
    }
    
}
