//
//  KindKit
//

import Foundation

extension UI.Container.Root {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var appearedView: IUIView?
        var statusBar: IUIView? {
            didSet {
                guard self.statusBar !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: IUIView {
            didSet {
                guard self.content !== oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            statusBar: IUIView?,
            content: IUIView
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
        
        func views(bounds: Rect) -> [IUIView] {
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
