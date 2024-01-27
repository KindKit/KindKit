//
//  KindKit
//

#if os(iOS)
import KindGraphics
import KindMath

public extension SegmentedView {
    
    struct Preset : Equatable {
        
        public let color: Color?
        public let textFont: Font?
        public let textColor: Color?
        
        public init(
            color: Color?,
            textFont: Font?,
            textColor: Color?
        ) {
            self.color = color
            self.textFont = textFont
            self.textColor = textColor
        }
        
    }
    
}

public extension SegmentedView.Preset {
    
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
