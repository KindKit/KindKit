//
//  KindKit
//

import KindMonadicMacro

@Monadic
public final class OptionalCallback< Result, Argument > : Callback< Result, Argument > {
    
    @MonadicField
    public var callback: Callback< Result, Argument >?
    
    @MonadicField
    public var `default`: Result
    
    public init(
        `default`: Result
    ) {
        self.default = `default`
        super.init()
    }
    
    public convenience init< Wrapped >() where Result == Optional< Wrapped > {
        self.init(default: nil)
    }
    
    public override func perform(_ argument: Argument) -> Result {
        guard let callback = self.callback else {
            return self.default
        }
        return callback.perform(argument)
    }
    
}
