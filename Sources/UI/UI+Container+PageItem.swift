//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class PageItem {
        
        var container: IUIPageContentContainer
        var bar: UI.View.PageBar.Item
        var barItem: UI.Layout.Item
        var view: IUIView
        var viewItem: UI.Layout.Item
        
        init(
            _ container: IUIPageContentContainer,
            _ inset: InsetFloat = .zero
        ) {
            self.container = container
            self.bar = container.pageItem
            self.barItem = UI.Layout.Item(container.pageItem)
            self.view = container.view
            self.viewItem = UI.Layout.Item(container.view)
        }
        
        func update() {
            self.bar = self.container.pageItem
            self.barItem = UI.Layout.Item(self.container.pageItem)
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

