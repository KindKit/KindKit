//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Input.Measurement.Complex.Part {
    
    struct Item : Equatable {
        
        public let title: String
        public let value: Double
        
        public init(
            title: String,
            value: Double
        ) {
            self.title = title
            self.value = value
        }
        
    }
        
}

#endif
