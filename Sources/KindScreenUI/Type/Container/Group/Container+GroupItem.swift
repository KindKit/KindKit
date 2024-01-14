//
//  KindKit
//

import KindUI

extension Container {
    
    final class GroupItem {
        
        var container: IGroupContentContainer
        var bar: GroupBarView.Item
        var view: IView

        init(
            _ container: IGroupContentContainer,
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

extension Container.GroupItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Container.GroupItem : Equatable {
    
    static func == (lhs: Container.GroupItem, rhs: Container.GroupItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
