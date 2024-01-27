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
    
    public weak var layout: ILayout?
    
    public var isLoaded: Bool {
        return self._item.isLoaded
    }
    
    public var view: ItemType.Content {
        return self._item.content
    }
    
    public var handle: NativeView {
        return self._item.content
    }
    
    public var owner: IOwner? {
        didSet {
            guard self.owner !== oldValue else { return }
            if self.owner != nil {
                self.onAppear.emit(self._numberOfAppeared == 0)
                self._numberOfAppeared += 1
            } else {
                self.onDisappear.emit()
            }
        }
    }
    
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            if self._item.isLoaded == true {
                self._item.content.kk_update(frame: self.frame)
            }
        }
    }
    
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.update(force: true)
        }
    }
    
    public let onAppear = Signal< Void, Bool >()
    
    public let onDisappear = Signal< Void, Void >()
    
    private var _item: LazyItem< ItemType >!
    private var _numberOfAppeared: UInt = 0
    
    public init(_ owner: ItemType.Owner) {
        self._item = .init(owner)
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard self.isHidden == false else { return .zero }
        return self._item.owner.sizeOf(request)
    }
    
}
