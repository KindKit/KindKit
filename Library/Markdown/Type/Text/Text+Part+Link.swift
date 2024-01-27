//
//  KindKit
//

import Foundation

public extension Text.Part {
    
    struct Link : Equatable {
        
        public let text: Text
        public let url: URL?
        
        public init(
            text: Text,
            url: URL?
        ) {
            self.text = text
            self.url = url
        }
        
    }
    
}
