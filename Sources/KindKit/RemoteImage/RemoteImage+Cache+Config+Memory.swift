//
//  KindKit
//

import Foundation

public extension RemoteImage.Cache.Config {

    struct Memory {

        public let maxImageArea: Double
        
        public init(
            maxImageArea: Double = 2048 * 2048
        ) {
            self.maxImageArea = maxImageArea
        }
        
    }

}
