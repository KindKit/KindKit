//
//  KindKit
//

extension Text.Ranges {
    
    public struct Item : Equatable, Hashable {
        
        public internal(set) var range: Text.Range
        public internal(set) var value: ValueType
        
        public init(range: Text.Range, value: ValueType) {
            self.range = range
            self.value = value
        }
        
        public init(lower: Text.Index, upper: Text.Index, value: ValueType) {
            self.range = .init(lower: lower, upper: upper)
            self.value = value
        }
        
    }
    
}

extension Text.Ranges.Item : CustomStringConvertible where ValueType : CustomStringConvertible {
    
    public var description: String {
        return "{\(self.range.lower), \(self.range.upper)} - \(self.value)"
    }
    
}
