//
//  KindKit
//

public protocol IBatchUpdate : AnyObject {
    
    @discardableResult
    func lockUpdate() -> Self
    
    @discardableResult
    func unlockUpdate() -> Self
    
    @discardableResult
    func update() -> Self
    
}

public extension IBatchUpdate {
    
    @inlinable
    @discardableResult
    func update(`on` block: () -> Void) -> Self {
        self.lockUpdate()
        block()
        self.unlockUpdate()
        return self
    }
    
}

public extension IBatchUpdate where Self : IComposite, BodyType : IBatchUpdate {
    
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
