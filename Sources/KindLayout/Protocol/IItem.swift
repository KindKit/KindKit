//
//  KindKit
//

import KindMath

public protocol IItem : AnyObject {
    
    var layout: ILayout? { set get }
    var owner: IOwner? { set get }
    var frame: Rect { set get }
    var isHidden: Bool { set get }
    
    func sizeOf(_ request: SizeRequest) -> Size
    
}

public extension IItem where Self : IComposite, BodyType : IItem {
    
    @inlinable
    var layout: ILayout? {
        set { self.body.layout = newValue }
        get { self.body.layout }
    }
    
    @inlinable
    var owner: IOwner? {
        set { self.body.owner = newValue }
        get { self.body.owner }
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

public extension IItem {
    
    @inlinable
    func update(force: Bool) {
        guard let layout = self.layout else { return }
        if force == true {
            layout.invalidate()
        }
        layout.update()
    }
    
}
