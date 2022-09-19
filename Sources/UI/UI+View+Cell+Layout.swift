//
//  KindKit
//

import Foundation

extension UI.View.Cell {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var contentItem: UI.Layout.Item {
            didSet { self.setNeedForceUpdate() }
        }
        
        init(
            contentItem: UI.Layout.Item
        ) {
            self.contentItem = contentItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.contentItem.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.contentItem.size(available: available)
            return Size(width: available.width, height: contentSize.height)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            return [ self.contentItem ]
        }
        
    }
    
}
