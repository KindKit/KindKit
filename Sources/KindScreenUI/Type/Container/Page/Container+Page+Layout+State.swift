//
//  KindKit
//

import KindMath

extension Container.Page.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(current: Container.PageItem)
        case forward(current: Container.PageItem, next: Container.PageItem, progress: Percent)
        case backward(current: Container.PageItem, next: Container.PageItem, progress: Percent)
        
    }
    
}
