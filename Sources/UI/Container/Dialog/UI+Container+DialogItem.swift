//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class DialogItem {
        
        var container: IUIDialogContentContainer
        var view: IUIView
        var background: (IUIView & IUIViewAlphable)?
        
        init(
            _ container: IUIDialogContentContainer,
            _ available: Size
        ) {
            self.container = container
            self.view = container.view
            self.background = container.dialogBackground
        }
        
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
