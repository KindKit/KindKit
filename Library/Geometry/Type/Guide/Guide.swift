//
//  KindKit
//

public protocol Guide : AnyObject {
    
    associatedtype Value
    
    var isEnabled: Bool { set get }
    
    func guide(_ value: Value) -> Value

}

public extension Guide {
    
    @inlinable
    @discardableResult
    func isEnabled(_ value: Bool) -> Self {
        self.isEnabled = value
        return self
    }
    
    @inlinable
    @discardableResult
    func isEnabled(on: () -> Bool) -> Self {
        self.isEnabled = on()
        return self
    }

    @inlinable
    @discardableResult
    func isEnabled(on: (Self) -> Bool) -> Self {
        self.isEnabled = on(self)
        return self
    }
    
}
