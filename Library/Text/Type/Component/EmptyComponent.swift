//
//  KindKit
//

public struct EmptyComponent : Component {
    
    public var part: Text.Part {
        return .init("")
    }
    
    public init() {
    }
    
}
