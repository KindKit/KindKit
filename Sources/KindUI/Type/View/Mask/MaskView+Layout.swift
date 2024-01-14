//
//  KindKit
//

import KindMath

extension MaskView {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var content: IView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            guard let content = self.content else { return .zero }
            content.frame = bounds
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            guard let content = self.content else { return .zero }
            return content.size(available: available)
        }
        
        func views(bounds: Rect) -> [IView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
