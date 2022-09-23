//
//  KindKit
//

import Foundation

public extension RemoteImage.Filter {
    
    final class Group : IRemoteImageFilter {

        public var name: String
        
        private let _filters: [IRemoteImageFilter]
        
        public init(
            _ filters: [IRemoteImageFilter]
        ) {
            self.name = filters.compactMap({ $0.name }).joined(separator: "-")
            self._filters = filters
        }
        
        public func apply(_ image: UI.Image) -> UI.Image? {
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
