//
//  KindKit
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import KindEvent
import KindLayout

public final class LazyLayoutItem< ItemType : ILazyable > : ILayoutItem where ItemType.Owner : IView, ItemType.Content : NativeView {
    
    public unowned(unsafe) var layout: ILayout?
    
    public var isLoaded: Bool {
        return self._lazy.isLoaded
    }
    
    public var view: ItemType.Content {
        return self._lazy.content
    }
    
    public var handle: NativeView {
        return self._lazy.content
    }
    
    public var position: Position? {
        didSet {
            guard self.position != oldValue else { return }
            if let position = oldValue {
                position.disappear(self)
                self.onDisappear.emit()
            }
            if let position = self.position {
                position.appear(self)
                self.onAppear.emit(self._numberOfAppeared == 0)
                self._numberOfAppeared += 1
            }
        }
    }
    
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self._lazy.isLoaded == true {
                self._lazy.content.kk_update(frame: self.frame)
            }
        }
    }
    
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.update(force: true)
        }
    }
    
    public var isLocked: Bool = false
    
    public let onAppear = Signal< Void, Bool >()
    
    public let onDisappear = Signal< Void, Void >()
    
    private var _lazy: LazyItem< ItemType >!
    private var _numberOfAppeared: UInt = 0
    
    public init(_ owner: ItemType.Owner) {
        self._lazy = .init(owner)
    }
    
    deinit {
        self._lazy.unload()
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard self.isHidden == false else { return .zero }
        return self._lazy.owner.sizeOf(request)
    }
    
}
