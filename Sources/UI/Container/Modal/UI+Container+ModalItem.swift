//
//  KindKit
//

import Foundation

extension UI.Container {
    
    final class ModalItem {
        
        let container: IUIModalContentContainer
        let owner: AnyObject?
        let view: UI.View.Mask
        let sheetInset: KindKit.Inset?
        let sheetBackground: (IUIView & IUIViewAlphable)?
        
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
            self.sheetInset = container.modalSheetInset
            self.sheetBackground = container.modalSheetBackground
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
