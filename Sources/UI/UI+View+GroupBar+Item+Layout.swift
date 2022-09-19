//
//  KindKit
//

import Foundation

extension UI.View.GroupBar.Item {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var contentInset: InsetFloat = InsetFloat(horizontal: 8, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var contentItem: UI.Layout.Item {
            didSet { self.setNeedForceUpdate(item: self.contentItem) }
        }
        
        init(
            _ contentView: IUIView
        ) {
            self.contentItem = UI.Layout.Item(contentView)
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.contentItem.frame = bounds.inset(self.contentInset)
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            let contentSize = self.contentItem.size(available: available.inset(self.contentInset))
            let contentBounds = contentSize.inset(-self.contentInset)
            return contentBounds
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            return [ self.contentItem ]
        }
        
    }
    
}
