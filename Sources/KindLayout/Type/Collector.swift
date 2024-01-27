//
//  KindKit
//

import KindMath

public final class Collector {
    
    public let bounds: Rect
    public private(set) var items: [IItem] = []
    
    public init(
        bounds: Rect
    ) {
        self.bounds = bounds
    }
    
}

public extension Collector {
    
    func push(_ item: IItem) {
        self.items.append(item)
    }
    
}
