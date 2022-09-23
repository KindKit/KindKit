//
//  KindKit
//

import Foundation

extension UI.Container.State {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var content: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
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
