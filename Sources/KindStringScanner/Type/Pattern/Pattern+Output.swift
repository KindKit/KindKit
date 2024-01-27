//
//  KindKit
//

extension Pattern {
    
    public struct Output : Equatable {
        
        public let range: Range< String.Index >?
        
        public var isEmpty: Bool {
            return self._data.isEmpty
        }
        
        private var _data: [String : Pattern.Match] = [:]
        
        init(_ data: [String : Pattern.Match]) {
            self.range = data.range
            self._data = data
        }

        init(_ context: Context) {
            self.init(context.result)
        }
        
        public subscript(string key: String) -> String? {
            guard let part = self._data[key] else { return nil }
            return part.full?.string
        }
        
        public subscript< KeyType : RawRepresentable >(string key: KeyType) -> String? where KeyType.RawValue == String {
            return self[string: key.rawValue]
        }
        
        public subscript(range key: String) -> Range< String.Index >? {
            guard let part = self._data[key] else { return nil }
            return part.full?.range
        }
        
        public subscript< KeyType : RawRepresentable >(range key: KeyType) -> Range< String.Index >? where KeyType.RawValue == String {
            return self[range: key.rawValue]
        }
        
    }
    
}

fileprivate extension Dictionary where Key == String, Value == Pattern.Match {
    
    var range: Range< String.Index >? {
        var range: Range< String.Index >? = nil
        for value in self.values {
            guard let valueRange = value.full?.range else { return nil }
            if let lastRange = range {
                range = .init(uncheckedBounds: (
                    lower: Swift.min(lastRange.lowerBound, valueRange.lowerBound),
                    upper: Swift.max(lastRange.upperBound, valueRange.upperBound)
                ))
            } else {
                range = valueRange
            }
        }
        return range
    }
    
}
