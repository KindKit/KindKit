//
//  KindKit
//

import Foundation

extension UI.Container.Screen {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        
        var inset: Inset = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IUIView? {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init() {
        }
        
        func layout(bounds: Rect) -> Size {
            guard let content = self.content else {
                return .zero
            }
            content.frame = bounds.inset(self.inset)
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            guard let content = self.content else {
                return .zero
            }
            let itemSize = content.size(available: available.inset(self.inset))
            return itemSize.inset(-self.inset)
        }
        
        func views(bounds: Rect) -> [IUIView] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
