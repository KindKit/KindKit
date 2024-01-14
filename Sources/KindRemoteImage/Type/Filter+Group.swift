//
//  KindKit
//

import KindGraphics

public extension Filter {
    
    final class Group : IFilter {

        public var name: String
        
        private let _filters: [IFilter]
        
        public init(
            _ filters: [IFilter]
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
    
}
