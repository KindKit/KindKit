//
//  KindKit
//

import Foundation

extension UI.Container.Modal.Layout {
    
    enum State {
        
        case empty
        case idle(modal: UI.Container.Modal.Item)
        case present(modal: UI.Container.Modal.Item, progress: PercentFloat)
        case dismiss(modal: UI.Container.Modal.Item, progress: PercentFloat)
        
    }
    
}
