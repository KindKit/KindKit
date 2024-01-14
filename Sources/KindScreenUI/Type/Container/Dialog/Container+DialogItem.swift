//
//  KindKit
//

import KindUI

extension Container {
    
    final class DialogItem {
        
        let container: IDialogContentContainer
        
        init(
            _ container: IDialogContentContainer,
            _ available: Size
        ) {
            self.container = container
        }
        
    }
    
}

extension Container.DialogItem {
    
    @inlinable
    var view: IView {
        return container.view
    }
    
    @inlinable
    var background: (IView & IViewAlphable)? {
        return container.dialogBackground
    }
    
}

extension Container.DialogItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Container.DialogItem : Equatable {
    
    static func == (lhs: Container.DialogItem, rhs: Container.DialogItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
