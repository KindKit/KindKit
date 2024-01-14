//
//  KindKit
//

import KindEvent

public final class Custom : IEntity {
    
    public let observer = Observer< IObserver >()
    
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
