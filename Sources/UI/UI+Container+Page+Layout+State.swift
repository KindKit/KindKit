//
//  KindKit
//

import Foundation

extension UI.Container.Page.Layout {
    
    enum State : Equatable {
        
        case empty
        case idle(current: UI.Container.PageItem)
        case forward(current: UI.Container.PageItem, next: UI.Container.PageItem, progress: PercentFloat)
        case backward(current: UI.Container.PageItem, next: UI.Container.PageItem, progress: PercentFloat)
        
    }
    
}
