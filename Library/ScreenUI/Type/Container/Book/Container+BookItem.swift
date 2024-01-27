//
//  KindKit
//

import KindUI

extension Container {
    
    final class BookItem {
        
        var container: IBookContentContainer
        var view: IView
        
        init(
            _ container: IBookContentContainer
        ) {
            self.container = container
            self.view = container.view
        }
        
    }
    
}

extension Container.BookItem : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

extension Container.BookItem : Equatable {
    
    static func == (lhs: Container.BookItem, rhs: Container.BookItem) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
}
