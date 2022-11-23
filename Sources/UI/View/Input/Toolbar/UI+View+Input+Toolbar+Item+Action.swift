//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.View.Input.Toolbar.Item {
    
    struct Action : IInputToolbarItem {
        
        public var barItem: UIBarButtonItem
        public var callback: () -> Void
        
        public init(
            text: String,
            callback: @escaping () -> Void
        ) {
            self.callback = callback
            self.barItem = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
        }
        
        public init(
            image: UI.Image,
            callback: @escaping () -> Void
        ) {
            self.callback = callback
            self.barItem = UIBarButtonItem(image: image.native, style: .plain, target: nil, action: nil)
        }
        
        public init(
            system: UIBarButtonItem.SystemItem,
            callback: @escaping () -> Void
        ) {
            self.callback = callback
            self.barItem = UIBarButtonItem(barButtonSystemItem: system, target: nil, action: nil)
        }
        
        public func pressed() {
            self.callback()
        }
        
    }
    
}

public extension IInputToolbarItem {
    
    @inlinable
    static func action(
        text: String,
        callback: @escaping () -> Void
    ) -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(text: text, callback: callback)
    }
    
    @inlinable
    static func action(
        image: UI.Image,
        callback: @escaping () -> Void
    ) -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(image: image, callback: callback)
    }
    
    @inlinable
    static func action(
        system: UIBarButtonItem.SystemItem,
        callback: @escaping () -> Void
    ) -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(system: system, callback: callback)
    }
    
}

#endif
