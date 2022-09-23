//
//  KindKit
//

import Foundation

extension UI.Container.Stack.Item {
    
    final class Layout : IUILayout {
        
        unowned var delegate: IUILayoutDelegate?
        unowned var view: IUIView?
        var bar: UI.Layout.Item {
            didSet { self.setNeedUpdate() }
        }
        var barVisibility: Float {
            didSet { self.setNeedUpdate() }
        }
        var barHidden: Bool {
            didSet { self.setNeedUpdate() }
        }
        var barOffset: Float = 0 {
            didSet { self.setNeedUpdate() }
        }
        var barSize: Float = 0
        var content: UI.Layout.Item
        
        init(
            bar: UI.Layout.Item,
            barVisibility: Float,
            barHidden: Bool,
            barOffset: Float,
            content: UI.Layout.Item
        ) {
            self.bar = bar
            self.barVisibility = barVisibility
            self.barHidden = barHidden
            self.barOffset = barOffset
            self.content = content
        }
        
        func layout(bounds: RectFloat) -> SizeFloat {
            if self.barHidden == false {
                let barSize = self.bar.size(available: SizeFloat(
                    width: bounds.width,
                    height: .infinity
                ))
                self.bar.frame = RectFloat(
                    x: bounds.x,
                    y: bounds.y,
                    width: bounds.width,
                    height: self.barOffset + (barSize.height * self.barVisibility)
                )
                self.barSize = barSize.height
            }
            self.content.frame = bounds
            return bounds.size
        }
        
        func size(available: SizeFloat) -> SizeFloat {
            return available
        }
        
        func items(bounds: RectFloat) -> [UI.Layout.Item] {
            var items: [UI.Layout.Item] = [ self.content ]
            if self.barHidden == false {
                items.append(self.bar)
            }
            return items
        }
        
    }
    
}
