//
//  KindKit
//

import Foundation

extension UI.Container.Book.Layout {
    
    enum State {
        
        case empty
        case idle(current: UI.Layout.Item)
        case forward(current: UI.Layout.Item, next: UI.Layout.Item, progress: PercentFloat)
        case backward(current: UI.Layout.Item, next: UI.Layout.Item, progress: PercentFloat)
        
    }
    
}
