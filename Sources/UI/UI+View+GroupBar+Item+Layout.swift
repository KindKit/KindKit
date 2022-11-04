//
//  KindKit
//

import Foundation

extension UI.View.GroupBar.Item {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var inset: InsetFloat = InsetFloat(horizontal: 8, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var content: UI.Layout.Item? {
            didSet { self.setNeedForceUpdate(item: self.content) }
        }
        
        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            guard let content = self.content else { return .zero }
            content.frame = bounds.inset(self.inset)
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let content = self.content else { return .zero }
            let size = content.size(available: available.inset(self.inset))
            return size.inset(-self.inset)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
