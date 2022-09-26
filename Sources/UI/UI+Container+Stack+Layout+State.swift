//
//  KindKit
//

import Foundation

extension UI.Container.Stack.Layout {
    
    enum State : Equatable {
        
        case idle(current: UI.Layout.Item)
        case push(current: UI.Layout.Item, forward: UI.Layout.Item, progress: PercentFloat)
        case pop(backward: UI.Layout.Item, current: UI.Layout.Item, progress: PercentFloat)
        
    }
    
}
