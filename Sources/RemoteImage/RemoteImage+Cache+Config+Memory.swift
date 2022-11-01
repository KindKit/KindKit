//
//  KindKit
//

import Foundation

public extension RemoteImage.Cache.Config {

    struct Memory {

        public let maxImageArea: Float
        
        public init(
            maxImageArea: Float = 2048 * 2048
        ) {
            self.maxImageArea = maxImageArea
        }
        
    }

}
