//
//  KindKit
//

import KindMath
import KindMonadicMacro

@KindMonadic
public final class ItemLayout< ItemType : IItem > : ILayout {
    
    public unowned(unsafe) var parent: ILayout?
    
    public unowned(unsafe) var owner: IOwner? {
        willSet {
            guard self.owner !== newValue else { return }
            if let owner = self.owner {
                owner.onUnlockUpdate(remove: self)
                owner.onLockUpdate(remove: self)
            }
        }
        didSet {
            guard self.owner !== oldValue else { return }
            if let owner = self.owner {
                owner.onLockUpdate(self, { $0._onLock() })
                owner.onUnlockUpdate(self, { $0._onUnlock() })
            }
        }
    }
    
    public private(set) var frame: Rect = .zero {
        didSet {
            self.content.frame = self.frame
        }
    }
    
    @KindMonadicProperty
    public var content: ItemType {
        willSet {
            self.content.layout = nil
        }
        didSet {
            self.content.layout = self
            self.content.frame = self.frame
            self.invalidate()
            self.update()
        }
    }
    
    private let _content = ElementCache()
    
    public init(_ content: ItemType) {
        self.content = content
        
        self.content.layout = self
    }
    
    deinit {
        self.content.layout = nil
    }
    
    public func invalidate() {
        self._content.reset()
    }
    
    public func invalidate(_ layout: ILayout) {
    }
    
    public func sizeOf(_ request: SizeRequest) -> Size {
        guard self.content.isHidden == false else { return .zero }
        return self._content.sizeOf(request, content: content)
    }
    
    public func arrange(_ request: ArrangeRequest) -> Size {
        guard content.isHidden == false else { return .zero }
        if request.available.width.isInfinite == true || request.available.height.isInfinite == true {
            let size = self._content.sizeOf(request, content: self.content)
            self.frame = .init(origin: request.container.origin, size: size)
        } else {
            self.frame = request.container
        }
        return self.frame.size
    }
    
    public func collect(_ collector: Collector) {
        guard self.content.isHidden == false else { return }
        collector.push(self.content)
    }
    
}

private extension ItemLayout {
    
    func _onLock() {
        self.content.isLocked = true
    }

    func _onUnlock() {
        self.content.isLocked = false
    }

}
