//
//  KindKit
//

import Foundation

public extension UI.View.Input {

    struct Placeholder : Equatable {
        
        public var text: Swift.String
        public var font: UI.Font
        public var color: UI.Color
        
        public init(
            text: Swift.String,
            font: UI.Font,
            color: UI.Color
        ) {
            self.text = text
            self.font = font
            self.color = color
        }
        
        public init< Localized : IEnumLocalized >(
            text: Localized,
            font: UI.Font,
            color: UI.Color
        ) {
            self.text = text.localized
            self.font = font
            self.color = color
        }

    }
    
}
