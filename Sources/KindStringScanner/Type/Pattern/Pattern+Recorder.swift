//
//  KindKit
//

extension Pattern {
    
    public final class Recorder {
        
        public let key: String
        
        private var _match = Pattern.Match()
        
        public init(_ key: String) {
            self.key = key
        }
        
        public func append(_ part: Scanner.Result) {
            self._match = self._match.append(part)
        }
        
        public func commit() -> Pattern.Match {
            let match = self._match
            self.reset()
            return match
        }
        
        public func reset() {
            self._match = .init()
        }

    }
    
}
