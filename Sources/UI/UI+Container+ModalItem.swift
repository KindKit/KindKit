//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class ModalItem {
        
        let container: IUIModalContentContainer
        let owner: AnyObject?
        let view: UI.View.Mask
        let viewItem: UI.Layout.Item
        let sheetInset: InsetFloat?
        let sheetBackground: (IUIView & IUIViewAlphable)?
        let sheetBackgroundItem: UI.Layout.Item?
        
        init(
            _ container: IUIModalContentContainer,
            _ owner: AnyObject? = nil
        ) {
            self.container = container
            self.owner = owner
            self.view = UI.View.Mask()
                .content(container.view)
                .cornerRadius(container.modalCornerRadius)
                .color(container.modalColor)
            self.viewItem = UI.Layout.Item(self.view)
            self.sheetInset = container.modalSheetInset
            self.sheetBackground = container.modalSheetBackground
            self.sheetBackgroundItem = container.modalSheetBackground.flatMap({ UI.Layout.Item($0) })
        }

    }
    
}

extension UI.Container.ModalItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension UI.Container.ModalItem : Equatable {
    
    static func == (lhs: UI.Container.ModalItem, rhs: UI.Container.ModalItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
