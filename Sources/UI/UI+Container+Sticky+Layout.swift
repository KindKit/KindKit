//
//  KindKit
//

import Foundation

extension UI.Container.Sticky {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var contentItem: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        var overlayItem: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        var overlayInset: Float {
            didSet { self.setNeedUpdate() }
        }
        var overlayVisibility: Float {
            didSet { self.setNeedUpdate() }
        }
        var overlayHidden: Bool {
            didSet { self.setNeedUpdate() }
        }
        var overlaySize: SizeFloat?
        
        init(
            contentItem: UI.Layout.Item,
            overlayItem: UI.Layout.Item,
            overlayInset: Float = 0,
            overlayVisibility: Float = 0,
            overlayHidden: Bool
        ) {
            self.contentItem = contentItem
            self.overlayItem = overlayItem
            self.overlayInset = overlayInset
            self.overlayVisibility = overlayVisibility
            self.overlayHidden = overlayHidden
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.contentItem.frame = bounds
            if self.overlayHidden == false {
                let overlaySize = self.overlayItem.size(available: bounds.size)
                self.overlayItem.frame = RectFloat(
                    bottomLeft: bounds.bottomLeft,
                    size: SizeFloat(
                        width: bounds.size.width,
                        height: self.overlayInset + (overlaySize.height * self.overlayVisibility)
                    )
                )
                self.overlaySize = overlaySize
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            if self.overlayHidden == false {
                return [ self.contentItem, self.overlayItem ]
            }
            return [ self.contentItem ]
        }
        
    }
    
}
