//
//  KindKit
//

import Foundation

extension UI.Container.Screen {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var item: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }
        
        init() {
            
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            guard let item = self.item else {
                return .zero
            }
            item.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let item = self.item else {
                return .zero
            }
            return item.size(available: available)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let item = self.item else { return [] }
            return [ item ]
        }
        
    }
    
}
