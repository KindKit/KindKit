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
        let fit: Bool
        
        init(
            fit: Bool
        ) {
            self.fit = fit
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if self.fit == true {
                if let item = self.item {
                    item.frame = bounds
                }
                return .zero
            }
            if let item = self.item {
                item.frame = bounds
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            if self.fit == true {
                if let item = self.item {
                    return item.size(available: available)
                }
                return .zero
            }
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let item = self.item else { return [] }
            return [ item ]
        }
        
    }
    
}
