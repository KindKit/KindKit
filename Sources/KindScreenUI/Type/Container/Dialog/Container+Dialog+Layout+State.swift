//
//  KindKit
//

import KindMath

extension Container.Dialog.Layout {
    
    enum State : Equatable {
        
        case idle
        case present(progress: Percent)
        case dismiss(progress: Percent)
        
    }
    
}
