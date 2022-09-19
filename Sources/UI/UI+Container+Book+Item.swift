//
//  KindKit
//

import Foundation

extension UI.Container.Book {
    
    final class Item {
        
        var container: IUIBookContentContainer
        var bookItem: UI.Layout.Item
        
        init(
            container: IUIBookContentContainer
        ) {
            self.container = container
            self.bookItem = UI.Layout.Item(container.view)
        }
        
    }
    
}
