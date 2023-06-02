//
//  KindKit
//

import Foundation

extension UI.View.Mask {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedForceUpdate()
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
        
        func views(bounds: Rect) -> [IUIView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
