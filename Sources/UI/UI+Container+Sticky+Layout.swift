//
//  KindKit
//

import Foundation

extension UI.Container.Sticky {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var content: UI.Layout.Item {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var sticky: UI.Layout.Item {
            didSet {
                guard self.sticky != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var stickyInset: Float {
            didSet {
                guard self.stickyInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var stickyVisibility: Float {
            didSet {
                guard self.stickyVisibility != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var stickyHidden: Bool {
            didSet {
                guard self.stickyHidden != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var stickySize: SizeFloat?
        
        init(
            content: UI.Layout.Item,
            sticky: UI.Layout.Item,
            stickyInset: Float = 0,
            stickyVisibility: Float = 0,
            stickyHidden: Bool
        ) {
            self.content = content
            self.sticky = sticky
            self.stickyInset = stickyInset
            self.stickyVisibility = stickyVisibility
            self.stickyHidden = stickyHidden
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            self.content.frame = bounds
            if self.stickyHidden == false {
                let stickySize = self.sticky.size(available: bounds.size)
                self.sticky.frame = RectFloat(
                    bottomLeft: bounds.bottomLeft,
                    size: SizeFloat(
                        width: bounds.size.width,
                        height: self.stickyInset + (stickySize.height * self.stickyVisibility)
                    )
                )
                self.stickySize = stickySize
            }
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            if self.stickyHidden == false {
                return [ self.content, self.sticky ]
            }
            return [ self.content ]
        }
        
    }
    
}
