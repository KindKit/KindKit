//
//  KindKit
//

import Foundation

extension UI.Container.Sticky {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var content: IUIView {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var sticky: IUIView {
            didSet {
                guard self.sticky !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var stickyInset: Double {
            didSet {
                guard self.stickyInset != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var stickyVisibility: Double {
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
        var stickySize: Size?
        
        init(
            content: IUIView,
            sticky: IUIView,
            stickyInset: Double = 0,
            stickyVisibility: Double = 0,
            stickyHidden: Bool
        ) {
            self.content = content
            self.sticky = sticky
            self.stickyInset = stickyInset
            self.stickyVisibility = stickyVisibility
            self.stickyHidden = stickyHidden
        }
        
        func layout(bounds: Rect) -> Size {
            self.content.frame = bounds
            if self.stickyHidden == false {
                let stickySize = self.sticky.size(available: bounds.size)
                self.sticky.frame = Rect(
                    bottomLeft: bounds.bottomLeft,
                    size: Size(
                        width: bounds.size.width,
                        height: self.stickyInset + (stickySize.height * self.stickyVisibility)
                    )
                )
                self.stickySize = stickySize
            }
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IUIView] {
            if self.stickyHidden == false {
                return [ self.content, self.sticky ]
            }
            return [ self.content ]
        }
        
    }
    
}
