//
//  KindKit
//

import KindMath

extension Container.Stack.Layout {
    
    enum State : Equatable {
        
        case idle(current: Container.StackItem)
        case push(current: Container.StackItem, forward: Container.StackItem, progress: Percent)
        case pop(backward: Container.StackItem, current: Container.StackItem, progress: Percent)
        
    }
    
}
