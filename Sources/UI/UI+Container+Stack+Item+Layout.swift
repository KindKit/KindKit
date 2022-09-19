//
//  KindKit
//

import Foundation

extension UI.Container.Stack.Item {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var barOffset: Float {
            didSet { self.setNeedUpdate() }
        }
        var barSize: Float
        var barVisibility: Float {
            didSet { self.setNeedUpdate() }
        }
        var barHidden: Bool {
            didSet { self.setNeedUpdate() }
        }
        var barItem: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        var contentItem: UI.Layout.Item
        
        init(
            barOffset: Float,
            barVisibility: Float,
            barHidden: Bool,
            barItem: UI.Layout.Item,
            contentItem: UI.Layout.Item
        ) {
            self.barOffset = barOffset
            self.barSize = 0
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barItem = barItem
            self.contentItem = contentItem
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if self.barHidden == false {
                let barSize = self.barItem.size(available: SizeFloat(
                    width: bounds.width,
                    height: .infinity
                ))
                self.barItem.frame = RectFloat(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: self.barOffset + (barSize.height * self.barVisibility)
                )
                self.barSize = barSize.height
            }
            self.contentItem.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = [ self.contentItem ]
            if self.barHidden == false {
                items.append(self.barItem)
            }
            return items
        }
        
    }
    
}
