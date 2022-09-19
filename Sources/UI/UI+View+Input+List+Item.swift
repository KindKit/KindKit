//
//  KindKit
//

#if os(iOS)

import Foundation

public protocol IInputListItem : AnyObject {
    
    var title: String { get }
    
}

public extension UI.View.Input.List {
    
    final class Item< Value > : IInputListItem {
        
        public let title: String
        public let value: Value
        
        public init(
            title: String,
            value: Value
        ) {
            self.title = title
            self.value = value
        }
        
    }
    
}

#endif
