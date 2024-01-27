//
//  KindKit
//

public struct SpaceComponent : Component {
    
    public let string: String
    
    public init(_ count: Int = 1) {
        if count > 0 {
            self.string = String(repeating: " ", count: count)
        } else {
            self.string = ""
        }
    }
    
}
