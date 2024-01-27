//
//  KindKit
//

public struct LocalizedComponent : IComponent {
    
    public let string: String
    
    public init< InputType : ILocalized >(_ input: InputType) {
        self.string = input.localized
    }
    
}
