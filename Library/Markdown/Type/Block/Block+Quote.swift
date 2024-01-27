//
//  KindKit
//

public extension Block {
    
    struct Quote : Equatable {
        
        public let level: UInt
        public let content: Text
        
        public init(
            level: UInt,
            content: Text
        ) {
            self.level = level
            self.content = content
        }
        
    }
    
}
