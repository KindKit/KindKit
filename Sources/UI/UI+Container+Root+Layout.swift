//
//  KindKit
//

import Foundation

extension UI.Container.Root {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var statusBarItem: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }
        var overlayItem: UI.Layout.Item? {
            didSet { self.setNeedUpdate() }
        }
        var contentItem: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        
        init(
            statusBarItem: UI.Layout.Item?,
            overlayItem: UI.Layout.Item?,
            contentItem: UI.Layout.Item
        ) {
            self.statusBarItem = statusBarItem
            self.overlayItem = overlayItem
            self.contentItem = contentItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if let overlayItem = self.overlayItem {
                overlayItem.frame = bounds
            }
            if let statusBarItem = self.statusBarItem {
                let statusBarSize = statusBarItem.size(available: SizeFloat(
                    width: bounds.size.width,
                    height: .infinity
                ))
                statusBarItem.frame = RectFloat(
                    x: bounds.origin.x,
                    y: bounds.origin.y,
                    width: statusBarSize.width,
                    height: statusBarSize.height
                )
            }
            self.contentItem.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items = [
                self.contentItem
            ]
            if let statusBarItem = self.statusBarItem {
                items.append(statusBarItem)
            }
            if let overlayItem = self.overlayItem {
                items.append(overlayItem)
            }
            return items
        }
        
    }
    
}
