//
//  KindKit
//

import KindMath

public protocol IItem : AnyObject {
    
    var layout: ILayout? { set get }
    var position: Position? { set get }
    var frame: Rect { set get }
    var isHidden: Bool { set get }
    var isLocked: Bool { set get }
    
    func sizeOf(_ request: SizeRequest) -> Size
    
}

public extension IItem {
    
    @inlinable
    var owner: IOwner? {
        return self.layout?.owner
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

public extension IItem where Self : IComposite, BodyType : IItem {
    
    @inlinable
    var layout: ILayout? {
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
