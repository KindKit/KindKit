//
//  KindKit
//

import Foundation

extension UI.Container.Page {
    
    final class Item {
        
        var container: IUIPageContentContainer
        var barView: UI.View.PageBar.Item {
            return self.barItem.view as! UI.View.PageBar.Item
        }
        var barItem: UI.Layout.Item
        var pageView: IUIView {
            return self.pageItem.view
        }
        var pageItem: UI.Layout.Item
        
        init(
            container: IUIPageContentContainer,
            insets: InsetFloat = .zero
        ) {
            self.container = container
            self.barItem = UI.Layout.Item(container.pageItemView)
            self.pageItem = UI.Layout.Item(container.view)
        }
        
        func update() {
            self.barItem = UI.Layout.Item(self.container.pageItemView)
        }
        
    }
    
}
