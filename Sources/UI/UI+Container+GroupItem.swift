//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class GroupItem {
        
        var container: IUIGroupContentContainer
        var bar: UI.View.GroupBar.Item
        var barItem: UI.Layout.Item
        var view: IUIView
        var viewItem: UI.Layout.Item

        init(
            _ container: IUIGroupContentContainer,
            _ inset: InsetFloat = .zero
        ) {
            self.container = container
            self.bar = container.groupItem
            self.barItem = UI.Layout.Item(container.groupItem)
            self.view = container.view
            self.viewItem = UI.Layout.Item(container.view)
        }
        
        func update() {
            self.bar = self.container.groupItem
            self.barItem = UI.Layout.Item(self.container.groupItem)
        }

    }
    
}

extension UI.Container.GroupItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.GroupItem : Equatable {
    
    static func == (lhs: UI.Container.GroupItem, rhs: UI.Container.GroupItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
