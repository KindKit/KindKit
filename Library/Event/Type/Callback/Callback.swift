//
//  KindKit
//

import KindCore
import KindMonadicMacro

public class Callback< Result, Argument > : CancelTrait {
    
    public typealias PerformResult = Swift.Result< Result, Error >
    
    private weak var _source: UnsubscribeTrait?
    
    init() {
    }
    
    public func perform(_ argument: Argument) -> Result {
        fatalError()
    }
    
    public func contains(_ target: AnyObject) -> Bool {
        return false
    }
    
    public func cancel() {
        self.unsubscribeFromParent()
    }
    
    public func reset() {
        self._source = nil
    }
    
}

public extension Callback {
    
    @discardableResult
    func source(_ source: UnsubscribeTrait?) -> Self {
        self._source = source
        return self
    }
    
    func unsubscribeFromParent() {
        self._source?.unsubscribe(self)
        self.reset()
    }
    
}

public extension Callback where Argument == Void {
    
    func perform() -> Result {
        return self.perform(())
    }
    
}
