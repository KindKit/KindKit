//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Item {
        
        var container: IUIModalContentContainer
        var item: UI.Layout.Item
        var sheetInset: InsetFloat?
        var sheetBackground: (IUIView & IUIViewAlphable)?
        var sheetBackgroundItem: UI.Layout.Item?
        
        init(
            container: IUIModalContentContainer,
            item: UI.Layout.Item,
            sheetInset: InsetFloat?,
            sheetBackground: (IUIView & IUIViewAlphable)?
        ) {
            self.container = container
            self.item = item
            self.sheetInset = sheetInset
            self.sheetBackground = sheetBackground
            self.sheetBackgroundItem = sheetBackground.flatMap({ UI.Layout.Item($0) })
        }
        
        convenience init(container: IUIModalContentContainer) {
            self.init(
                container: container,
                item: UI.Layout.Item(container.view),
                sheetInset: container.modalSheetInset,
                sheetBackground: container.modalSheetBackground
            )
        }

    }
    
}
