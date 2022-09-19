//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.View.Input.Toolbar.Item {
    
    struct Space : IInputToolbarItem {
        
        public var barItem: UIBarButtonItem
        
        public init() {
            self.barItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        public func pressed() {
        }
        
    }
    
}

public extension IInputToolbarItem {

    @inlinable
    static func space() -> UI.View.Input.Toolbar.Item.Space {
        return UI.View.Input.Toolbar.Item.Space()
    }
    
}

#endif
