//
//  KindKit
//

import KindMath

extension Container.Group.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(current: Container.GroupItem)
        case forward(current: Container.GroupItem, next: Container.GroupItem, progress: Percent)
        case backward(current: Container.GroupItem, next: Container.GroupItem, progress: Percent)
        
    }
    
}
