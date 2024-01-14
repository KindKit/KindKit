//
//  KindKit
//

import KindUI

extension Container.Root {
    
    final class Layout : ILayout {
        
        weak var delegate: ILayoutDelegate?
        weak var appearedView: IView?
        var statusBar: IView? {
            didSet {
                guard self.statusBar !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IView {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            statusBar: IView?,
            content: IView
        ) {
            self.statusBar = statusBar
            self.content = content
        }
        
        func layout(bounds: Rect) -> Size {
            if let statusBar = self.statusBar {
                let statusBarSize = statusBar.size(available: Size(
                    width: bounds.size.width,
                    height: .infinity
                ))
                statusBar.frame = Rect(
                    x: bounds.origin.x,
                    y: bounds.origin.y,
                    width: statusBarSize.width,
                    height: statusBarSize.height
                )
            }
            self.content.frame = bounds
            return bounds.size
        }
        
        func size(available: Size) -> Size {
            return available
        }
        
        func views(bounds: Rect) -> [IView] {
            var items = [
                self.content
            ]
            if let statusBar = self.statusBar {
                items.append(statusBar)
            }
            return items
        }
        
    }
    
}
