//
//  KindKit
//

public struct EmptyInfo : Info {
    
    public init() {
    }
    
    public func build(
        options: Options,
        head: UInt,
        inter: UInt,
        tail: UInt
    ) -> String {
        return ""
    }
    
}
