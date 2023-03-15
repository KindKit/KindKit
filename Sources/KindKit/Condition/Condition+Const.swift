//
//  KindKit
//

import Foundation

public extension Condition {

    final class Const : ICondition {
        
        public let observer = Observer< IConditionObserver >()
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

}

public extension Condition.Const {
    
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

public extension ICondition where Self == Condition.Const {
    
    @inlinable
    static func const(
        _ state: Bool
    ) -> Self {
        return .init(state)
    }
    
}
