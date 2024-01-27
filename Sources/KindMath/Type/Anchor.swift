//
//  KindKit
//

public struct Anchor : Equatable, Hashable {
    
    public var x: Percent
    public var y: Percent
    
    public init(
        x: Percent,
        y: Percent
    ) {
        self.x = x
        self.y = y
    }
    
}
