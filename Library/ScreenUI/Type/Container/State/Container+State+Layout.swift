//
//  KindKit
//

import KindUI

extension Container.State {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var content: IView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(_ content: IView?) {
            self.content = content
        }
        
        func layout(bounds: Rect) -> Size {
            self.content?.frame = bounds
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
