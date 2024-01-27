//
//  KindKit
//

public struct IntegerArgument< Value : BinaryInteger > : Argument {
    
    let value: Value
    let fallback: String
    
    public init(_ value: Value, fallback: String = "") {
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
