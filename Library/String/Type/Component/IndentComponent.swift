//
//  KindKit
//

public struct IndentComponent : Component {
    
    public let string: String
    
    public init< Count : BinaryInteger >(_ count: Count) {
        if count > 0 {
            self.string = String(repeating: "\t", count: .init(count))
        } else {
            self.string = ""
        }
    }
    
}
