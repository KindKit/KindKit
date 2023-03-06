//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class GroupItem {
        
        var container: IUIGroupContentContainer
        var bar: UI.View.GroupBar.Item
        var view: IUIView

        init(
            _ container: IUIGroupContentContainer,
            _ inset: Inset = .zero
        ) {
            self.container = container
            self.bar = container.groupItem
            self.view = container.view
        }
        
        func update() {
            self.bar = self.container.groupItem
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
