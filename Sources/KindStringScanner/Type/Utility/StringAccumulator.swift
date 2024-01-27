//
//  KindKit
//

public final class StringAccumulator : IAccumulator {
    
    private var _buffer: String
    
    public init() {
        self._buffer = ""
    }
    
    public func append(input: String) {
        self._buffer.append(input)
    }
    
    public func append(part: String) {
        self._buffer.append(part)
    }
    
    public func result() -> String {
        return self._buffer
    }
    
}
