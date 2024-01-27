//
//  KindKit
//

extension Cache.Config {

    public struct Memory {

        public let maxImageArea: Double
        
        public init(
            maxImageArea: Double = 2048 * 2048
        ) {
            self.maxImageArea = maxImageArea
        }
        
    }

}
