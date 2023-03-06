//
//  KindKit
//

import Foundation

extension UI.View.GroupBar.Item {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var inset: Inset = Inset(horizontal: 8, vertical: 4) {
            didSet { self.setNeedForceUpdate() }
        }
        var content: IUIView? {
            didSet { self.setNeedForceUpdate(self.content) }
        }
        
        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            guard let content = self.content else { return .zero }
            content.frame = bounds.inset(self.inset)
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            guard let content = self.content else { return .zero }
            let size = content.size(available: available.inset(self.inset))
            return size.inset(-self.inset)
        }
        
        func views(bounds: Rect) -> [IUIView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
