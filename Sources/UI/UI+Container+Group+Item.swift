//
//  KindKit
//

import Foundation

extension UI.Container.Group {
    
    final class Item {
        
        var container: IUIGroupContentContainer
        var bar: UI.View.GroupBar.Item {
            return self.barItem.view as! UI.View.GroupBar.Item
        }
        var barItem: UI.Layout.Item
        var group: IUIView {
            return self.groupItem.view
        }
        var groupItem: UI.Layout.Item

        init(
            container: IUIGroupContentContainer,
            insets: InsetFloat = .zero
        ) {
            self.container = container
            self.barItem = UI.Layout.Item(container.groupItem)
            self.groupItem = UI.Layout.Item(container.view)
        }
        
        func update() {
            self.barItem = UI.Layout.Item(self.container.groupItem)
        }

    }
    
}
