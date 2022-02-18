//
//  KindKitView
//

import Foundation
import KindKitCore
import KindKitMath

public struct InputPlaceholder {
    
    public var text: String
    public var font: Font
    public var color: Color
    
    @inlinable
    public init(
        text: String,
        font: Font,
        color: Color
    ) {
        self.text = text
        self.font = font
        self.color = color
    }

}
