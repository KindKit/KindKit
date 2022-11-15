//
//  KindKit
//

import Foundation

extension UI.Container.Group.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(current: UI.Container.GroupItem)
        case forward(current: UI.Container.GroupItem, next: UI.Container.GroupItem, progress: PercentFloat)
        case backward(current: UI.Container.GroupItem, next: UI.Container.GroupItem, progress: PercentFloat)
        
    }
    
}
