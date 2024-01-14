//
//  KindKit
//

#if os(iOS)

import UIKit
import KindEvent
import KindGraphics

public extension InputToolbarView {
    
    final class ActionItem : IInputToolbarItem {
        
        public let barItem: UIBarButtonItem
        public let onPressed = Signal< Void, Void >()
        
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
            image: Image
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

public extension InputToolbarView.ActionItem {
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping () -> Void) -> Self {
        self.onPressed.add(closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed(_ closure: @escaping (Self) -> Void) -> Self {
        self.onPressed.add(self, closure)
        return self
    }
    
    @inlinable
    @discardableResult
    func onPressed< Sender : AnyObject >(_ sender: Sender, _ closure: @escaping (Sender) -> Void) -> Self {
        self.onPressed.add(sender, closure)
        return self
    }
    
}

public extension InputToolbarView.ActionItem {
    
    @inlinable
    static func plain(_ text: String) -> Self {
        return .init(plain: text)
    }
    
    @inlinable
    static func bold(_ text: String) -> Self {
        return .init(bold: text)
    }
    
    @inlinable
    static func image(_ image: Image) -> Self {
        return .init(image: image)
    }
    
    @inlinable
    static func done() -> Self {
        return .init(item: .done)
    }
    
    @inlinable
    static func cancel() -> Self {
        return .init(item: .cancel)
    }
    
    @inlinable
    static func edit() -> Self {
        return .init(item: .edit)
    }
    
    @inlinable
    static func save() -> Self {
        return .init(item: .save)
    }
    
    @inlinable
    static func add() -> Self {
        return .init(item: .add)
    }
    
    @inlinable
    static func compose() -> Self {
        return .init(item: .compose)
    }
    
    @inlinable
    static func reply() -> Self {
        return .init(item: .reply)
    }
    
    @inlinable
    static func action() -> Self {
        return .init(item: .action)
    }
    
    @inlinable
    static func organize() -> Self {
        return .init(item: .organize)
    }
    
    @inlinable
    static func bookmarks() -> Self {
        return .init(item: .bookmarks)
    }
    
    @inlinable
    static func search() -> Self {
        return .init(item: .search)
    }
    
    @inlinable
    static func refresh() -> Self {
        return .init(item: .refresh)
    }
    
    @inlinable
    static func stop() -> Self {
        return .init(item: .stop)
    }
    
    @inlinable
    static func camera() -> Self {
        return .init(item: .camera)
    }
    
    @inlinable
    static func trash() -> Self {
        return .init(item: .trash)
    }
    
    @inlinable
    static func play() -> Self {
        return .init(item: .play)
    }
    
    @inlinable
    static func pause() -> Self {
        return .init(item: .pause)
    }
    
    @inlinable
    static func rewind() -> Self {
        return .init(item: .rewind)
    }
    
    @inlinable
    static func fastForward() -> Self {
        return .init(item: .fastForward)
    }
    
    @inlinable
    static func undo() -> Self {
        return .init(item: .undo)
    }
    
    @inlinable
    static func redo() -> Self {
        return .init(item: .redo)
    }
    
    @inlinable
    @available(iOS 13.0, *)
    static func close() -> Self {
        return .init(item: .close)
    }
    
}

#endif
