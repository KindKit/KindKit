//
//  KindKit
//

import Foundation

extension UI.Container.Modal {
    
    final class Item {
        
        let owner: AnyObject?
        let container: IUIModalContentContainer
        let view: UI.View.Mask
        let item: UI.Layout.Item
        let sheetInset: InsetFloat?
        let sheetBackground: (IUIView & IUIViewAlphable)?
        let sheetBackgroundItem: UI.Layout.Item?
        
        init(
            owner: AnyObject? = nil,
            container: IUIModalContentContainer
        ) {
            self.owner = owner
            self.container = container
            self.view = UI.View.Mask()
                .content(container.view)
                .cornerRadius(container.modalCornerRadius)
                .color(container.modalColor)
            self.item = UI.Layout.Item(self.view)
            self.sheetInset = container.modalSheetInset
            self.sheetBackground = container.modalSheetBackground
            self.sheetBackgroundItem = self.sheetBackground.flatMap({ UI.Layout.Item($0) })
        }

    }
    
}

extension UI.Container.Modal.Item : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.Modal.Item : Equatable {
    
    static func == (lhs: UI.Container.Modal.Item, rhs: UI.Container.Modal.Item) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
