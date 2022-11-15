//
//  KindKit
//

import Foundation

extension UI.Container.Stack.Layout {
    
    enum State : Equatable {
        
        case idle(current: UI.Container.StackItem)
        case push(current: UI.Container.StackItem, forward: UI.Container.StackItem, progress: PercentFloat)
        case pop(backward: UI.Container.StackItem, current: UI.Container.StackItem, progress: PercentFloat)
        
    }
    
}
