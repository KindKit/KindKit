//
//  KindKit
//

import Foundation

extension UI.Container.Root {
    
    final class Layout : IUILayout {
        
        weak var delegate: IUILayoutDelegate?
        weak var view: IUIView?
        var statusBar: UI.Layout.Item? {
            didSet {
                guard self.statusBar != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        var content: UI.Layout.Item {
            didSet {
                guard self.content != oldValue else { return }
                self.setNeedUpdate()
            }
        }
        
        init(
            statusBar: UI.Layout.Item?,
            content: UI.Layout.Item
        ) {
            self.statusBar = statusBar
            self.content = content
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let statusBar = self.statusBar {
                let statusBarSize = statusBar.size(available: SizeFloat(
                    width: bounds.size.width,
                    height: .infinity
                ))
                statusBar.frame = RectFloat(
                    x: bounds.origin.x,
                    y: bounds.origin.y,
                    width: statusBarSize.width,
                    height: statusBarSize.height
                )
            }
            self.content.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
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
