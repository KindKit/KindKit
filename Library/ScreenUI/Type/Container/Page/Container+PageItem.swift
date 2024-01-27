//
//  KindKit
//

import KindUI

extension Container {
    
    final class PageItem {
        
        var container: IPageContentContainer
        var bar: PageBarView.Item
        var view: IView
        
        init(
            _ container: IPageContentContainer
        ) {
            self.container = container
            self.bar = container.pageItem
            self.view = container.view
        }
        
        func update() {
            self.bar = self.container.pageItem
        }
        
    }
    
}

extension Container.PageItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Container.PageItem : Equatable {
    
    static func == (lhs: Container.PageItem, rhs: Container.PageItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}

