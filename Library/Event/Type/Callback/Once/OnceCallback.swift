//
//  KindKit
//

public final class OnceCallback< Result, Argument > : Callback< Result, Argument > {
    
    private let _callback: (Argument) -> Result
    private var _result: Result?
    
    public init(
        callback: @escaping (Argument) -> Result
    ) {
        self._callback = callback
        super.init()
    }
    
    public override func perform(_ argument: Argument) -> Result {
        if let result = self._result {
            return result
        }
        let result = self._callback(argument)
        self._result = result
        self.unsubscribeFromParent()
        return result
    }
    
}

public extension OnceCallback {
    
    convenience init(
        callback: @escaping () -> Result
    ) {
        self.init(callback: { _ in
            return callback()
        })
    }
    
}
