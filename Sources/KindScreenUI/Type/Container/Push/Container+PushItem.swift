//
//  KindKit
//

import KindUI

extension Container {
    
    final class PushItem {
        
        let container: IPushContentContainer
        private(set) var viewSize: Size
        
        init(
            _ container: IPushContentContainer,
            _ available: Size,
            _ parentInset: Inset,
            _ contentInset: Inset
        ) {
            self.container = container
            if container.pushOptions.contains(.useContentInset) == true {
                self.viewSize = container.view.size(available: available.inset(contentInset))
            } else {
                self.viewSize = container.view.size(available: available.inset(parentInset))
            }
        }
        
        func update(
            _ available: Size,
            _ parentInset: Inset,
            _ contentInset: Inset
        ) {
            if self.container.pushOptions.contains(.useContentInset) == true {
                self.viewSize = self.container.view.size(available: available.inset(contentInset))
            } else {
                self.viewSize = self.container.view.size(available: available.inset(parentInset))
            }
        }
        
    }
    
}

extension Container.PushItem {
    
    @inlinable
    var view: IView {
        return container.view
    }
    
}

extension Container.PushItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Container.PushItem : Equatable {
    
    static func == (lhs: Container.PushItem, rhs: Container.PushItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
