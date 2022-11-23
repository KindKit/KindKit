//
//  KindKit
//

import Foundation

extension UI.Container.State {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(_ content: IUIView?) {
            self.content = content
        }
        
        func layout(bounds: Rect) -> Size {
            self.content?.frame = bounds
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IUIView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
