//
//  KindKit
//

import Foundation

extension UI.View.Mask {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        
        var content: UI.Layout.Item? {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            guard let content = self.content else { return .zero }
            content.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let content = self.content else { return .zero }
            return content.size(available: available)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
