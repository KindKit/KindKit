//
//  KindKit
//

#if os(iOS)

import Foundation

public extension UI.View.Segmented {
    
    struct Preset : Equatable {
        
        public let color: UI.Color?
        public let textFont: UI.Font?
        public let textColor: UI.Color?
        
        public init(
            color: UI.Color?,
            textFont: UI.Font?,
            textColor: UI.Color?
        ) {
            self.color = color
            self.textFont = textFont
            self.textColor = textColor
        }
        
    }
    
}

public extension UI.View.Segmented.Preset {
    
    var attributes: [NSAttributedString.Key : Any] {
        var attributes: [NSAttributedString.Key : Any] = [:]
        if let textFont = self.textFont {
            attributes[.font] = textFont.native
        }
        if let textColor = self.textColor {
            attributes[.foregroundColor] = textColor.native
        }
        return attributes
    }
    
}

#endif
