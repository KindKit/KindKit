//
//  KindKit
//

extension Text.Part.Ranges {
    
    public struct Item {
        
        public internal(set) var range: Text.Part.Range
        public internal(set) var value: Value
        
        public init(range: Text.Part.Range, value: Value) {
            self.range = range
            self.value = value
        }
        
        public init(lower: Text.Part.Index, upper: Text.Part.Index, value: Value) {
            self.range = .init(lower: lower, upper: upper)
            self.value = value
        }
        
    }
    
}

extension Text.Part.Ranges.Item : Hashable {
}

extension Text.Part.Ranges.Item : Equatable {
}

extension Text.Part.Ranges.Item : Sendable {
}

extension Text.Part.Ranges.Item : CustomStringConvertible where Value : CustomStringConvertible {
    
    public var description: String {
        return "{\(self.range.lower), \(self.range.upper)} - \(self.value)"
    }
    
}
