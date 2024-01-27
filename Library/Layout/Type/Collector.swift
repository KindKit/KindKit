//
//  KindKit
//

import KindGeometry

public final class Collector {
    
    public let bounds: Rect
    public private(set) var items: [any Item] = []
    
    public init(
        bounds: Rect
    ) {
        self.bounds = bounds
    }
    
}

public extension Collector {
    
    func push(_ item: any Item) {
        self.items.append(item)
    }
    
}
