//
//  KindKit
//

public final class OnceTargetCallback< Target : AnyObject, Result, Argument > : Callback< Result, Argument > {
    
    public typealias Capture = KindEvent.Capture< Target, Result >
    
    private var _capture: Capture
    private let _callback: (Target, Argument) -> Result
    private var _result: Result?
    
    public init(
        capture: Capture,
        callback: @escaping (Target, Argument) -> Result
    ) {
        self._capture = capture
        self._callback = callback
        super.init()
    }
    
    public override func contains(_ target: AnyObject) -> Bool {
        return self._capture.contains(target)
    }
    
    public override func perform(_ argument: Argument) -> Result {
        if let result = self._result {
            return result
        }
        let result: Result
        switch self._capture {
        case .strong(let target):
            result = self._callback(target.content, argument)
        case .weak(let object, let `default`):
            if let target = object.content {
                result = self._callback(target, argument)
            } else {
                result = `default`
            }
        }
        self._result = result
        self.unsubscribeFromParent()
        return result
    }
    
}

public extension OnceTargetCallback {
    
    convenience init(
        capture: Capture,
        callback: @escaping (Target) -> Result
    ) {
        self.init(
            capture: capture,
            callback: { target, _ in
                return callback(target)
            }
        )
    }
    
}
