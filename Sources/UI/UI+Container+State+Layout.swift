//
//  KindKit
//

import Foundation

extension UI.Container.State {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var item: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }
        
        init(item: UI.Layout.Item?) {
            self.item = item
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.item?.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let item = self.item else { return [] }
            return [ item ]
        }
        
    }
    
}
