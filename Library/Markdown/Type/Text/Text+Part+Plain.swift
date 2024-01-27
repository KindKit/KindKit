//
//  KindKit
//

public extension Text.Part {
    
    struct Plain : Equatable {
        
        public let options: Text.Options
        public let text: String
        
        public init(
            options: Text.Options = [],
            text: String
        ) {
            self.options = options
            self.text = text
        }
        
    }
    
}
