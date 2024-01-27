//
//  KindKit
//

public struct IntegerArgument< ValueType : BinaryInteger > : IArgument {
    
    let value: ValueType
    let fallback: String
    
    public init(_ value: ValueType, fallback: String = "") {
        self.value = value
        self.fallback = fallback
    }
    
    public func string(_ specifier: Specifier) -> String {
        guard let value = specifier.format(self.value) else {
            return self.fallback
        }
        return value
    }
    
}
