//
//  KindKit
//

import Foundation

extension UI.Container.Page.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(current: UI.Layout.Item)
        case forward(current: UI.Layout.Item, next: UI.Layout.Item, progress: PercentFloat)
        case backward(current: UI.Layout.Item, next: UI.Layout.Item, progress: PercentFloat)
        
    }
    
}
