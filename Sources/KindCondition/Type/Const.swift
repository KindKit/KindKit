//
//  KindKit
//

import KindEvent

public final class Const : IEntity {
    
    public let observer = Observer< IObserver >()
    public var state: Bool {
        didSet {
            guard self.state != oldValue else { return }
            self.notifyChanged()
        }
    }
    
    public init(_ state: Bool) {
        self.state = state
    }
    
    public func refresh() {
    }
    
    public func callAsFunction() -> Bool {
        return self.state
    }
    
}

public extension Const {
    
    @inlinable
    @discardableResult
    func state(_ value: Bool) -> Self {
        self.state = value
        return self
    }
    
    @inlinable
    @discardableResult
    func state(_ value: () -> Bool) -> Self {
        return self.state(value())
    }

    @inlinable
    @discardableResult
    func state(_ value: (Self) -> Bool) -> Self {
        return self.state(value(self))
    }
    
}
