//
//  KindKit
//

import Foundation

extension UI.Container.Modal.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(modal: UI.Container.ModalItem)
        case present(modal: UI.Container.ModalItem, progress: PercentFloat)
        case dismiss(modal: UI.Container.ModalItem, progress: PercentFloat)
        
    }
    
}
