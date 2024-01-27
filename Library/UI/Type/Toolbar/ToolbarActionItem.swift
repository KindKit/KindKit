//
//  KindKit
//

#if os(iOS)

import UIKit
import KindEvent
import KindGraphics
import KindMonadicMacro

@Monadic
public final class ToolbarActionItem : IToolbarItem {
   
   public let handle: UIBarButtonItem
    
    @MonadicSignal
   public let onPressed = Signal< Void, Void >()
   
   public init(
       plain text: String
   ) {
       self.handle = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
   }
   
   public init(
       bold text: String
   ) {
       self.handle = UIBarButtonItem(title: text, style: .done, target: nil, action: nil)
   }
   
   public init(
       image: Image
   ) {
       self.handle = UIBarButtonItem(image: image.native, style: .plain, target: nil, action: nil)
   }
   
   public init(
       system: UIBarButtonItem.SystemItem
   ) {
       self.handle = UIBarButtonItem(barButtonSystemItem: system, target: nil, action: nil)
   }
   
   public func pressed() {
       self.onPressed.emit()
   }
   
}

public extension ToolbarActionItem {
    
    @inlinable
    static func text(plain text: String) -> Self {
        return .init(plain: text)
    }
    
    @inlinable
    static func text(bold text: String) -> Self {
        return .init(bold: text)
    }
    
    @inlinable
    static func image(_ image: Image) -> Self {
        return .init(image: image)
    }
    
}

public extension ToolbarActionItem {
    
    @inlinable
    static func done() -> Self {
        return .init(system: .done)
    }
    
    @inlinable
    static func cancel() -> Self {
        return .init(system: .cancel)
    }
    
    @inlinable
    static func edit() -> Self {
        return .init(system: .edit)
    }
    
    @inlinable
    static func save() -> Self {
        return .init(system: .save)
    }
    
    @inlinable
    static func add() -> Self {
        return .init(system: .add)
    }
    
    @inlinable
    static func compose() -> Self {
        return .init(system: .compose)
    }
    
    @inlinable
    static func reply() -> Self {
        return .init(system: .reply)
    }
    
    @inlinable
    static func action() -> Self {
        return .init(system: .action)
    }
    
    @inlinable
    static func organize() -> Self {
        return .init(system: .organize)
    }
    
    @inlinable
    static func bookmarks() -> Self {
        return .init(system: .bookmarks)
    }
    
    @inlinable
    static func search() -> Self {
        return .init(system: .search)
    }
    
    @inlinable
    static func refresh() -> Self {
        return .init(system: .refresh)
    }
    
    @inlinable
    static func stop() -> Self {
        return .init(system: .stop)
    }
    
    @inlinable
    static func camera() -> Self {
        return .init(system: .camera)
    }
    
    @inlinable
    static func trash() -> Self {
        return .init(system: .trash)
    }
    
    @inlinable
    static func play() -> Self {
        return .init(system: .play)
    }
    
    @inlinable
    static func pause() -> Self {
        return .init(system: .pause)
    }
    
    @inlinable
    static func rewind() -> Self {
        return .init(system: .rewind)
    }
    
    @inlinable
    static func fastForward() -> Self {
        return .init(system: .fastForward)
    }
    
    @inlinable
    static func undo() -> Self {
        return .init(system: .undo)
    }
    
    @inlinable
    static func redo() -> Self {
        return .init(system: .redo)
    }
    
    @inlinable
    static func close() -> Self {
        return .init(system: .close)
    }
    
}

#endif
