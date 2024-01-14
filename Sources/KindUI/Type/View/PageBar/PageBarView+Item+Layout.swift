//
//  KindKit
//

import KindMath

extension PageBarView.Item {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var inset: Inset = Inset(horizontal: 8, vertical: 4) {
            didSet { self.setNeedUpdate() }
        }
        var content: IView? {
            didSet { self.setNeedUpdate(self.content) }
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
        
        func views(bounds: Rect) -> [IView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
