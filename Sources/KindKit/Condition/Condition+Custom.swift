//
//  KindKit
//

import Foundation

public extension Condition {

    final class Custom : ICondition {
        
        public let observer = Observer< IConditionObserver >()
        
        private let _closure: () -> Bool
        private var _state: Bool {
            didSet {
                guard self._state != oldValue else { return }
                self.notifyChanged()
            }
        }
        
        public init(_ closure: @escaping () -> Bool) {
            self._state = closure()
            self._closure = closure
        }
        
        public func refresh() {
            self._state = self._closure()
        }
        
        public func callAsFunction() -> Bool {
            return self._state
        }
        
    }

}

public extension ICondition where Self == Condition.Custom {
    
    @inlinable
    static func custom(
        _ closure: @escaping () -> Bool
    ) -> Self {
        return .init(closure)
    }
    
}
