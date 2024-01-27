//
//  KindKit
//

public struct SpaceComponent : IComponent {
    
    public let string: String
    
    public init(_ count: Int = 1) {
        if count > 0 {
            self.string = String(repeating: " ", count: count)
        } else {
            self.string = ""
        }
    }
    
}
