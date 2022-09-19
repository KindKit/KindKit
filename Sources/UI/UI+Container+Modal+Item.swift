//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Item {
        
        var container: IUIModalContentContainer
        var item: UI.Layout.Item
        var sheetInset: InsetFloat?
        var sheetBackgroundView: (IUIView & IUIViewAlphable)?
        var sheetBackgroundItem: UI.Layout.Item?

        convenience init(container: IUIModalContentContainer) {
            self.init(
                container: container,
                item: UI.Layout.Item(container.view),
                sheetInset: container.modalSheetInset,
                sheetBackgroundView: container.modalSheetBackgroundView
            )
        }
        
        init(
            container: IUIModalContentContainer,
            item: UI.Layout.Item,
            sheetInset: InsetFloat?,
            sheetBackgroundView: (IUIView & IUIViewAlphable)?
        ) {
            self.container = container
            self.item = item
            self.sheetInset = sheetInset
            self.sheetBackgroundView = sheetBackgroundView
            self.sheetBackgroundItem = sheetBackgroundView.flatMap({ UI.Layout.Item($0) })
        }

    }
    
}
