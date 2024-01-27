//
//  KindKit
//

import KindEvent
import KindMonadicMacro

@KindMonadic
public final class Const : IEntity {
    
    public let observer = Observer< IObserver >()
    
    @KindMonadicProperty
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
