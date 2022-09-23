//
//  KindKit
//

import Foundation

extension UI.View.Cell {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var content: UI.Layout.Item {
            didSet { self.setNeedForceUpdate() }
        }
        
        init(
            _ content: IUIView
        ) {
            self.content = UI.Layout.Item(content)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.content.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.content.size(available: available)
            return Size(width: available.width, height: contentSize.height)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            return [ self.content ]
        }
        
    }
    
}
