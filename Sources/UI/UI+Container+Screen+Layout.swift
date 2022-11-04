//
//  KindKit
//

import Foundation

extension UI.Container.Screen {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        
        var inset: InsetFloat = .zero {
            didSet {
                guard self.inset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var item: UI.Layout.Item? {
            didSet {
                guard self.item != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init() {
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            guard let item = self.item else {
                return .zero
            }
            item.frame = bounds.inset(self.inset)
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            guard let item = self.item else {
                return .zero
            }
            let itemSize = item.size(available: available.inset(self.inset))
            return itemSize.inset(-self.inset)
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            guard let item = self.item else { return [] }
            return [ item ]
        }
        
    }
    
}
