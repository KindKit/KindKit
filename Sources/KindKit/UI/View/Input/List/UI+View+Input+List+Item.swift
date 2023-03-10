//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IInputListItem : AnyObject {
    
    var id: String { get }
    var title: String { get }
    
}

public extension UI.View.Input.List {
    
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

public extension IInputListItem where Self == UI.View.Input.List.Item {
    
    static func item(
        id: String = UUID().uuidString,
        title: String
    ) -> Self {
        return .init(
            id: id,
            title: title
        )
    }
    
}

#endif
