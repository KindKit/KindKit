//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class DialogItem {
        
        let container: IUIDialogContentContainer
        
        init(
            _ container: IUIDialogContentContainer,
            _ available: Size
        ) {
            self.container = container
        }
        
    }
    
}

extension UI.Container.DialogItem {
    
    @inlinable
    var view: IUIView {
        return container.view
    }
    
    @inlinable
    var background: (IUIView & IUIViewAlphable)? {
        return container.dialogBackground
    }
    
}

extension UI.Container.DialogItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.DialogItem : Equatable {
    
    static func == (lhs: UI.Container.DialogItem, rhs: UI.Container.DialogItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
