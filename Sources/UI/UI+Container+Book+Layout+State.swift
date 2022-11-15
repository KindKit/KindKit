//
//  KindKit
//

import Foundation

extension UI.Container.Book.Layout {
    
    enum State : Equatable {
        
        typealias Item = UI.Container.BookItem
        
        case empty
        case idle(current: Item)
        case forward(current: Item, next: Item, progress: PercentFloat)
        case backward(current: Item, next: Item, progress: PercentFloat)
        
    }
    
}
