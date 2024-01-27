//
//  KindKit
//

import KindGraphics

public final class SequenceFilter : Filter {
    
    public let name: String
    
    private let _filters: [Filter]
    
    public init(
        _ filters: [Filter]
    ) {
        self.name = filters.map({ $0.name }).joined(separator: "-")
        self._filters = filters
    }
    
    public func apply(_ image: Image) -> Image? {
        var result = image
        for filter in self._filters {
            guard let image = filter.apply(result) else {
                return nil
            }
            result = image
        }
        return result
    }
    
}
