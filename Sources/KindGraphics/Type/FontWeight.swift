//
//  KindKit
//

public struct FontWeight : Equatable, Hashable {
    
    public let value: UInt
    
    public init(_ value: UInt) {
        self.value = max(1, min(value, 1000))
    }
    
}

public extension FontWeight {
    
    /// Standart weight 100
    static let thin = Self(100)
    
    /// Standart weight 100
    static let hairline = Self(100)
    
    /// Standart weight 200
    static let extralight = Self(200)
    
    /// Standart weight 200
    static let ultralight = Self(200)
    
    /// Standart weight 300
    static let light = Self(300)
    
    /// Standart weight 400
    static let normal = Self(400)
    
    /// Standart weight 400
    static let regular = Self(400)
    
    /// Standart weight 500
    static let medium = Self(500)
    
    /// Standart weight 600
    static let semibold = Self(600)
    
    /// Standart weight 600
    static let demibold = Self(600)
    
    /// Standart weight 700
    static let bold = Self(700)
    
    /// Standart weight 800
    static let extrabold = Self(800)
    
    /// Standart weight 800
    static let ultrabold = Self(800)
    
    /// Standart weight 900
    static let black = Self(900)
    
    /// Standart weight 900
    static let heavy = Self(900)
    
    /// Standart weight 950
    static let extrablack = Self(950)
    
    /// Standart weight 950
    static let ultrablack = Self(950)
    
}
