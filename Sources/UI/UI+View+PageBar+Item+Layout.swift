//
//  KindKit
//

import Foundation

extension UI.View.PageBar.Item {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var inset: InsetFloat = InsetFloat(horizontal: 8, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var content: UI.Layout.Item {
            didSet { self.setNeedForceUpdate(item: self.content) }
        }
        
        init(
            _ content: IUIView
        ) {
            self.content = UI.Layout.Item(content)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.content.frame = bounds.inset(self.inset)
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.content.size(available: available.inset(self.inset))
            let contentBounds = contentSize.inset(-self.inset)
            return contentBounds
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            return [ self.content ]
        }
        
    }
    
}
