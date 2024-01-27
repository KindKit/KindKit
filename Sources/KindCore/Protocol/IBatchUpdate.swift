//
//  KindKit
//

public protocol IBatchUpdate {
    
    func lockUpdate()
    
    func unlockUpdate()
    
    func update()
    
}

public extension IBatchUpdate {
    
    @inlinable
    func update(`on` block: () -> Void) {
        self.lockUpdate()
        block()
        self.unlockUpdate()
    }
    
}

public extension IBatchUpdate where Self : IComposite, BodyType : IBatchUpdate {
    
    @inlinable
    func lockUpdate() {
        self.body.lockUpdate()
    }
    
    @inlinable
    func unlockUpdate() {
        self.body.unlockUpdate()
    }
    
    @inlinable
    func update() {
        self.body.update()
    }
    
}
