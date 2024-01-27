//
//  KindKit
//

public final class RegularTargetCallback< Target : AnyObject, Result, Argument > : Callback< Result, Argument > {
    
    public typealias Capture = KindEvent.Capture< Target, Result >
    
    private var _capture: Capture
    private let _callback: (Target, Argument) -> Result
    
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
        switch self._capture {
        case .strong(let target):
            return self._callback(target.content, argument)
        case .weak(let object, let `default`):
            guard let target = object.content else {
                self.unsubscribeFromParent()
                return `default`
            }
            return self._callback(target, argument)
        }
    }
    
}

public extension RegularTargetCallback {
    
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
