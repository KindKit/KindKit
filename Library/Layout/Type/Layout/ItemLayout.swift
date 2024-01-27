//
//  KindKit
//

import KindGeometry
import KindMonadicMacro

@Monadic
public final class ItemLayout< Item : KindLayout.Item > : Layout {
    
    public unowned(unsafe) var parent: (any Layout)?
    
    public unowned(unsafe) var scope: Scope? {
        willSet {
            guard self.scope !== newValue else { return }
            if let owner = self.scope {
                owner.onUnlockUpdate(disconnect: self)
                owner.onLockUpdate(disconnect: self)
            }
        }
        didSet {
            guard self.scope !== oldValue else { return }
            if let owner = self.scope {
                owner.onLockUpdate(target: self, regular: { $0._onLock() })
                owner.onUnlockUpdate(target: self, regular: { $0._onUnlock() })
            }
        }
    }
    
    public private(set) var frame: Rect = .zero {
        didSet {
            self.content.frame = self.frame
        }
    }
    
    @MonadicField
    public var content: Item {
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
    
    public init(_ content: Item) {
        self.content = content
        
        self.content.layout = self
    }
    
    deinit {
        self.content.layout = nil
    }
    
    public func invalidate() {
        self._content.reset()
    }
    
    public func invalidate(_ layout: any Layout) {
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
