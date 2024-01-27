//
//  KindKit
//

public struct IndentComponent : IComponent {
    
    public let string: String
    
    public init(_ count: Int) {
        if count > 0 {
            self.string = String(repeating: "\t", count: count)
        } else {
            self.string = ""
        }
    }
    
}
