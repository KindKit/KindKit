//
//  KindKit
//

public final class RegularCallback< Result, Argument > : Callback< Result, Argument > {
    
    private let _callback: (Argument) -> Result
    
    public init(
        callback: @escaping (Argument) -> Result
    ) {
        self._callback = callback
        super.init()
    }
    
    public override func perform(_ argument: Argument) -> Result {
        return self._callback(argument)
    }
    
}

public extension RegularCallback {
    
    convenience init(
        callback: @escaping () -> Result
    ) {
        self.init(callback: { _ in
            return callback()
        })
    }
    
}
