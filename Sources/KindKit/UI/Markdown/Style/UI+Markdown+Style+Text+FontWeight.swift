//
//  KindKit
//

import Foundation

public extension UI.Markdown.Style.Text {
    
    struct FontWeight : Equatable {
        
        public let value: UInt
        
        public init(_ value: UInt) {
            self.value = max(1, min(value, 1000))
        }
        
    }
    
}

public extension UI.Markdown.Style.Text.FontWeight {
    
    static let thin = Self(100)
    static let hairline = Self(100)
    static let extraLight = Self(200)
    static let ultraLight = Self(200)
    static let light = Self(300)
    static let normal = Self(400)
    static let regular = Self(400)
    static let medium = Self(500)
    static let semiBold = Self(600)
    static let demiBold = Self(600)
    static let bold = Self(700)
    static let extraBold = Self(800)
    static let ultraBold = Self(800)
    static let black = Self(900)
    static let heavy = Self(900)
    static let extraBlack = Self(950)
    static let ultraBlack = Self(950)
    
}
