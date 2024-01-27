//
//  KindKit
//

public struct LettersComponent : IComponent {
    
    public let string: String
    
    public init(_ string: String) {
        self.string = string
    }
    
    public init(_ string: String, escape: EscapeMode) {
        self.string = escape.apply(string)
    }
    
    public init< InputType : CustomStringConvertible >(_ input: InputType) {
        self.string = input.description
    }
    
    public init< InputType : CustomStringConvertible >(_ input: InputType, escape: EscapeMode) {
        self.string = escape.apply(input.description)
    }
    
}
