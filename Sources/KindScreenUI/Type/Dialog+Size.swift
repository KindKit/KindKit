//
//  KindKit
//

extension Dialog {
    
    public struct Size : Equatable {
        
        public var width: Dimension
        public var height: Dimension
        
        public init(
            _ width: Dimension,
            _ height: Dimension
        ) {
            self.width = width
            self.height = height
        }
        
    }
    
}
