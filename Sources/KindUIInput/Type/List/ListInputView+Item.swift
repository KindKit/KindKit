//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IInputListItem : AnyObject {
    
    var id: String { get }
    var title: String { get }
    
}

public extension ListInputView {
    
    final class Item : IInputListItem {
        
        public let id: String
        public let title: String
        
        public init(
            id: String = UUID().uuidString,
            title: String
        ) {
            self.id = id
            self.title = title
        }
        
    }
    
}

#endif
