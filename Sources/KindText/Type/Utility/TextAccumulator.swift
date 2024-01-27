//
//  KindKit
//

import KindGraphics
import KindStringScanner

public final class TextAccumulator : IAccumulator {
    
    private let _options: Text.Options
    private var _buffer: Text
    
    public init(options: Text.Options) {
        self._options = options
        self._buffer = .init()
    }
    
    public func append(input: String) {
        let range = self._buffer.append(input)
        if self._options.isEmpty == false {
            self._buffer.set(options: self._options, in: range)
        }
    }
    
    public func append(part: Text) {
        self._buffer.append(part)
    }
    
    public func result() -> Text {
        return self._buffer
    }
    
}
