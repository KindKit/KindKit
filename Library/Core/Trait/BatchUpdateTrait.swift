//
//  KindKit
//

public protocol BatchUpdateTrait : AnyObject {
    
    var isUpdateLocked: Bool { get }
    
    @discardableResult
    func lockUpdate() -> Self
    
    @discardableResult
    func unlockUpdate() -> Self
    
    @discardableResult
    func update() -> Self
    
}

public extension BatchUpdateTrait {
    
    @inlinable
    var isUpdateNotLocked: Bool {
        return !self.isUpdateLocked
    }
    
    @inlinable
    @discardableResult
    func update(`on` block: () -> Void) -> Self {
        self.lockUpdate()
        block()
        self.unlockUpdate()
        return self
    }
    
}

public extension BatchUpdateTrait where Self : CompositorTrait, Body : BatchUpdateTrait {
    
    @inlinable
    var isUpdateLocked: Bool {
        return self.body.isUpdateLocked
    }
    
    @inlinable
    @discardableResult
    func lockUpdate() -> Self {
        self.body.lockUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func unlockUpdate() -> Self {
        self.body.unlockUpdate()
        return self
    }
    
    @inlinable
    @discardableResult
    func update() -> Self {
        self.body.update()
        return self
    }
    
}
