//
//  KindKit
//

import Foundation

extension UI.Container.State {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var content: UI.Layout.Item? {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(_ content: UI.Layout.Item?) {
            self.content = content
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.content?.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let content = self.content else { return [] }
            return [ content ]
        }
        
    }
    
}
