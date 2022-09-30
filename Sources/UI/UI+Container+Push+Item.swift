//
//  KindKit
//

import Foundation

extension UI.Container.Push {
    
    final class Item {
        
        var container: IUIPushContentContainer
        var item: UI.Layout.Item
        var size: SizeFloat
        
        init(container: IUIPushContentContainer, available: SizeFloat) {
            self.container = container
            self.item = UI.Layout.Item(container.view)
            self.size = container.view.size(available: available)
        }
        
        func update(available: SizeFloat) {
            self.size = self.container.view.size(available: available)
        }
        
    }
    
}

extension UI.Container.Push.Item : Equatable {
    
    public static func == (lhs: UI.Container.Push.Item, rhs: UI.Container.Push.Item) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
