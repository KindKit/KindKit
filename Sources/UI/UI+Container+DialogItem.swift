//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class DialogItem {
        
        var container: IUIDialogContentContainer
        var view: IUIView
        var viewItem: UI.Layout.Item
        var background: (IUIView & IUIViewAlphable)?
        var backgroundItem: UI.Layout.Item?
        
        init(
            _ container: IUIDialogContentContainer,
            _ available: SizeFloat
        ) {
            self.container = container
            self.view = container.view
            self.viewItem = UI.Layout.Item(self.view)
            self.background = container.dialogBackground
            self.backgroundItem = container.dialogBackground.flatMap({ UI.Layout.Item($0) })
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
