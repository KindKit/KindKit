//
//  KindKit
//

public struct FontWeight {
    
    public let value: UInt
    
    public init(_ value: UInt) {
        self.value = max(1, min(value, 1000))
    }
    
}

extension FontWeight : Hashable {
}

extension FontWeight : Equatable {
}

extension FontWeight : Sendable {
}

public extension FontWeight {
    
    /// Standart weight 100
    @inlinable
    static var thin: Self {
        return .init(100)
    }
    
    /// Standart weight 100
    @inlinable
    static var hairline: Self {
        return .init(100)
    }
    
    /// Standart weight 200
    @inlinable
    static var extralight: Self {
        return .init(200)
    }
    
    /// Standart weight 200
    @inlinable
    static var ultralight: Self {
        return .init(200)
    }
    
    /// Standart weight 300
    @inlinable
    static var light: Self {
        return .init(300)
    }
    
    /// Standart weight 400
    @inlinable
    static var normal: Self {
        return .init(400)
    }
    
    /// Standart weight 400
    @inlinable
    static var regular: Self {
        return .init(400)
    }
    
    /// Standart weight 500
    @inlinable
    static var medium: Self {
        return .init(500)
    }
    
    /// Standart weight 600
    @inlinable
    static var semibold: Self {
        return .init(600)
    }
    
    /// Standart weight 600
    @inlinable
    static var demibold: Self {
        return .init(600)
    }
    
    /// Standart weight 700
    @inlinable
    static var bold: Self {
        return .init(700)
    }
    
    /// Standart weight 800
    @inlinable
    static var extrabold: Self {
        return .init(800)
    }
    
    /// Standart weight 800
    @inlinable
    static var ultrabold: Self {
        return .init(800)
    }
    
    /// Standart weight 900
    @inlinable
    static var black: Self {
        return .init(900)
    }
    
    /// Standart weight 900
    @inlinable
    static var heavy: Self {
        return .init(900)
    }
    
    /// Standart weight 950
    @inlinable
    static var extrablack: Self {
        return .init(950)
    }
    
    /// Standart weight 950
    @inlinable
    static var ultrablack: Self {
        return .init(950)
    }
    
}
