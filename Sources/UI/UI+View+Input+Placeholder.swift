//
//  KindKit
//

import Foundation

public extension UI.View.Input {

    struct Placeholder {
        
        public var text: Swift.String
        public var font: Font
        public var color: Color
        
        public init(
            text: Swift.String,
            font: Font,
            color: Color
        ) {
            self.text = text
            self.font = font
            self.color = color
        }

    }
    
}
