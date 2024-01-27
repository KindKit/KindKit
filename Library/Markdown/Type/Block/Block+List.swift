//
//  KindKit
//

public extension Block {
    
    struct List : Equatable {
        
        public let marker: Text
        public let content: Text
        
        public init(
            marker: Text,
            content: Text
        ) {
            self.marker = marker
            self.content = content
        }
        
    }
    
}
