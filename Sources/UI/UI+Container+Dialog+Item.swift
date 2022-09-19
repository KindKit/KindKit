//
//  KindKit
//

import Foundation

extension UI.Container.Dialog {
    
    final class Item {
        
        var container: IUIDialogContentContainer
        var item: UI.Layout.Item
        var backgroundView: (IUIView & IUIViewAlphable)?
        var backgroundItem: UI.Layout.Item?
        
        init(container: IUIDialogContentContainer, available: SizeFloat) {
            self.container = container
            self.item = UI.Layout.Item(container.view)
            if let backgroundView = container.dialogBackgroundView {
                self.backgroundView = backgroundView
                self.backgroundItem = UI.Layout.Item(backgroundView)
            }
        }
        
    }
    
}
