//
//  KindKit
//

import Foundation

extension UI.Container.Sticky {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var content: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        var overlay: UI.Layout.Item {
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
            content: UI.Layout.Item,
            overlay: UI.Layout.Item,
            overlayInset: Float = 0,
            overlayVisibility: Float = 0,
            overlayHidden: Bool
        ) {
            self.content = content
            self.overlay = overlay
            self.overlayInset = overlayInset
            self.overlayVisibility = overlayVisibility
            self.overlayHidden = overlayHidden
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.content.frame = bounds
            if self.overlayHidden == false {
                let overlaySize = self.overlay.size(available: bounds.size)
                self.overlay.frame = RectFloat(
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
                return [ self.content, self.overlay ]
            }
            return [ self.content ]
        }
        
    }
    
}
