//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UI.View.Input.Toolbar.Item {
    
    final class Action : IUIViewInputToolbarItem {
        
        public let barItem: UIBarButtonItem
        public let onPressed: Signal.Empty< Void > = .init()
        
        public init(
            plain text: String
        ) {
            self.barItem = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
        }
        
        public init(
            bold text: String
        ) {
            self.barItem = UIBarButtonItem(title: text, style: .done, target: nil, action: nil)
        }
        
        public init(
            image: UI.Image
        ) {
            self.barItem = UIBarButtonItem(image: image.native, style: .plain, target: nil, action: nil)
        }
        
        public init(
            item: UIBarButtonItem.SystemItem
        ) {
            self.barItem = UIBarButtonItem(barButtonSystemItem: item, target: nil, action: nil)
        }
        
        public func pressed() {
            self.onPressed.emit()
        }
        
    }
    
}

public extension UI.View.Input.Toolbar.Item.Action {
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: (() -> Void)?) -> Self {
        self.onPressed.link(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressed.link(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressed.link(sender, closure)
        return self
    }
    
}

public extension IUIViewInputToolbarItem where Self == UI.View.Input.Toolbar.Item.Action {
    
    @inlinable
    static func plain(
        _ text: String
    ) -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(plain: text)
    }
    
    @inlinable
    static func bold(
        _ text: String
    ) -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(bold: text)
    }
    
    @inlinable
    static func image(
        _ image: UI.Image
    ) -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(image: image)
    }
    
    @inlinable
    static func done() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .done)
    }
    
    @inlinable
    static func cancel() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .cancel)
    }
    
    @inlinable
    static func edit() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .edit)
    }
    
    @inlinable
    static func save() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .save)
    }
    
    @inlinable
    static func add() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .add)
    }
    
    @inlinable
    static func compose() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .compose)
    }
    
    @inlinable
    static func reply() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .reply)
    }
    
    @inlinable
    static func action() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .action)
    }
    
    @inlinable
    static func organize() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .organize)
    }
    
    @inlinable
    static func bookmarks() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .bookmarks)
    }
    
    @inlinable
    static func search() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .search)
    }
    
    @inlinable
    static func refresh() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .refresh)
    }
    
    @inlinable
    static func stop() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .stop)
    }
    
    @inlinable
    static func camera() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .camera)
    }
    
    @inlinable
    static func trash() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .trash)
    }
    
    @inlinable
    static func play() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .play)
    }
    
    @inlinable
    static func pause() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .pause)
    }
    
    @inlinable
    static func rewind() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .rewind)
    }
    
    @inlinable
    static func fastForward() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .fastForward)
    }
    
    @inlinable
    static func undo() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .undo)
    }
    
    @inlinable
    static func redo() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .redo)
    }
    
    @inlinable
    @available(iOS 13.0, *)
    static func close() -> UI.View.Input.Toolbar.Item.Action {
        return UI.View.Input.Toolbar.Item.Action(item: .close)
    }
    
}

#endif
