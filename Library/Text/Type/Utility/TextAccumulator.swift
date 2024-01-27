//
//  KindKit
//

import KindGraphics
import KindStringPattern

public final class TextAccumulator : Accumulator {
    
    private let _options: Options
    private var _buffer: Text.Part
    
    public init(options: Options) {
        self._options = options
        self._buffer = .init()
    }
    
    public func append(input: String) {
        let range = self._buffer.append(input)
        if self._options.isEmpty == false {
            self._buffer.set(options: self._options, in: range)
        }
    }
    
    public func append(part: Text.Part) {
        self._buffer.append(part)
    }
    
    public func result() -> Text.Part {
        return self._buffer
    }
    
}
