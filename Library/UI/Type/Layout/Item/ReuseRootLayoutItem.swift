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

public final class ReuseRootLayoutItem< Item : ReuseTrait, Layout : ILayout > : ILayoutItem where Item.Owner : IView, Item.Content : NativeView {
    
    public unowned(unsafe) var layout: (any ILayout)?
    
    public var isLoaded: Bool {
        return self._reuse.isLoaded
    }
    
    public var view: Item.Content {
        return self._reuse.content
    }
    
    public var handle: NativeView {
        return self._reuse.content
    }
    
    public var position: Position? {
        didSet {
            guard self.position != oldValue else { return }
            if let position = oldValue {
                self.onDisappear.emit()
                position.disappear(self)
                self._reuse.disappear()
                self.manager.lockUpdate()
            }
            if let position = self.position {
                position.appear(self)
                self.manager.unlockUpdate()
                self.onAppear.emit(self._numberOfAppeared == 0)
                self._numberOfAppeared += 1
            }
        }
    }
    
    public var frame: Rect = .zero {
        didSet {
            guard self.frame != oldValue else { return }
            self.manager.viewSize = self.frame.size
            if self._reuse.isLoaded == true {
                self._reuse.content.kk_update(frame: self.frame)
            }
        }
    }
    
    public var isHidden: Bool = false {
        didSet {
            guard self.isHidden != oldValue else { return }
            self.update(force: true)
        }
    }
    
    public var isLocked: Bool = false {
        didSet {
            guard self.isLocked != oldValue else { return }
            if self.isLocked == true {
                self.manager.lockUpdate()
            } else {
                self.manager.unlockUpdate()
            }
        }
    }
    
    public let onAppear = Signal< Void, Bool >()
    
    public let onDisappear = Signal< Void, Void >()
    
    public let manager = KindLayout.Manager< Layout >()
        .lockUpdate()
    
    private var _reuse: ReuseItem< Item >!
    private var _numberOfAppeared: UInt = 0
    
    public init(_ owner: Item.Owner) {
        self._reuse = .init(owner)
        
        self.manager.onInvalidate(self, { $0._onInvalidate() })
    }
    
    deinit {
        self._reuse.unload()
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard self.isHidden == false else { return .zero }
        return self.manager.sizeOf(request)
    }
    
}

private extension ReuseRootLayoutItem {
    
    final func _onInvalidate() -> Bool? {
        self.update(force: true)
        return self.layout == nil
    }
    
}
