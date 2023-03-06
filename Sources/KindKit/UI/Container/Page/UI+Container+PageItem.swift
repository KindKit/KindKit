//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class PageItem {
        
        var container: IUIPageContentContainer
        var bar: UI.View.PageBar.Item
        var view: IUIView
        
        init(
            _ container: IUIPageContentContainer
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

extension UI.Container.PageItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.PageItem : Equatable {
    
    static func == (lhs: UI.Container.PageItem, rhs: UI.Container.PageItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}

