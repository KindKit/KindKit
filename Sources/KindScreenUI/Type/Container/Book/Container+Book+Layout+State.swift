//
//  KindKit
//

import KindMath

extension Container.Book.Layout {
    
    enum State : Equatable {
        
        typealias Item = Container.BookItem
        
        case empty
        case idle(current: Item)
        case forward(current: Item, next: Item, progress: Percent)
        case backward(current: Item, next: Item, progress: Percent)
        
    }
    
}
