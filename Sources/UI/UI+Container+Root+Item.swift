//
//  KindKit
//

import Foundation

extension UI.Container.Root {
    
    final class Item {
        
        var container: IUIRootContentContainer
        var owner: AnyObject?
        var view: IUIView {
            return self.item.view
        }
        var item: UI.Layout.Item
        
        init(
            container: IUIRootContentContainer,
            owner: AnyObject? = nil
        ) {
            self.container = container
            self.owner = owner
            self.item = UI.Layout.Item(container.view)
        }
        
    }
    
}

extension UI.Container.Root.Item : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.Root.Item : Equatable {
    
    public static func == (lhs: UI.Container.Root.Item, rhs: UI.Container.Root.Item) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
