//
//  KindKit
//

import KindGeometry

public protocol Item : AnyObject, Equatable {
    
    var layout: (any Layout)? { set get }
    var position: Position? { set get }
    var frame: Rect { set get }
    var isHidden: Bool { set get }
    var isLocked: Bool { set get }
    
    func sizeOf(_ request: SizeRequest) -> Size
    
}

public extension Item {
    
    @inlinable
    var owner: Scope? {
        return self.layout?.scope
    }
    
    @inlinable
    func lockUpdate() {
        self.owner?.lockUpdate()
    }
    
    @inlinable
    func unlockUpdate() {
        self.owner?.unlockUpdate()
    }
    
    @inlinable
    func update(force: Bool) {
        guard let layout = self.layout else { return }
        if force == true {
            layout.invalidate()
        }
        layout.update()
    }
    
}

extension Item {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
}

public extension Item where Self : CompositorTrait, Body : Item {
    
    @inlinable
    var layout: (any Layout)? {
        set { self.body.layout = newValue }
        get { self.body.layout }
    }
    
    @inlinable
    var position: Position? {
        set { self.body.position = newValue }
        get { self.body.position }
    }
    
    @inlinable
    var frame: Rect {
        set { self.body.frame = newValue }
        get { self.body.frame }
    }
    
    @inlinable
    var isHidden: Bool {
        return self.body.isHidden
    }
    
    @inlinable
    func sizeOf(_ request: SizeRequest) -> Size {
        return self.body.sizeOf(request)
    }
    
}
