//
//  KindKit
//

import KindMath

extension Container.Hamburger.Layout {
    
    enum State : Equatable {
        
        case idle
        case leading(progress: Percent)
        case trailing(progress: Percent)
        
    }
    
}
