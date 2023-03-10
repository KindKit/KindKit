//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.View.Input.Toolbar.Item {
    
    final class Space : IInputToolbarItem {
        
        public let barItem: UIBarButtonItem
        
        public init() {
            self.barItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        
        public init(
            width: Double
        ) {
            self.barItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            self.barItem.width = CGFloat(width)
        }
        
        public func pressed() {
        }
        
    }
    
}

public extension IInputToolbarItem where Self == UI.View.Input.Toolbar.Item.Space {

    @inlinable
    static func flexible() -> UI.View.Input.Toolbar.Item.Space {
        return UI.View.Input.Toolbar.Item.Space()
    }
    
    @inlinable
    static func fixed(_ width: Double) -> UI.View.Input.Toolbar.Item.Space {
        return UI.View.Input.Toolbar.Item.Space(width: width)
    }
    
}

#endif
