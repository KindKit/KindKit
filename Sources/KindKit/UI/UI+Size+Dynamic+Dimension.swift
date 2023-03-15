//
//  KindKit
//

import Foundation

public extension UI.Size.Dynamic {

    enum Dimension : Equatable {
        
        case parent(Percent)
        case ratio(Percent)
        case fixed(Double)
        case content(Percent)
        
    }
    
}

public extension UI.Size.Dynamic.Dimension {
    
    static var none: Self {
        return .fixed(0)
    }
    
    static var fill: Self {
        return .parent(.one)
    }
    
    static var fit: Self {
        return .content(.one)
    }
    
    static func parent(_ value: Double) -> Self {
        return .parent(Percent(value))
    }
    
    static func ratio(_ value: Double) -> Self {
        return .ratio(Percent(value))
    }
    
    static func content(_ value: Double) -> Self {
        return .content(Percent(value))
    }
    
}

public extension UI.Size.Dynamic.Dimension {
    
    var isStatic: Bool {
        switch self {
        case .parent, .ratio, .fixed: return true
        case .content: return false
        }
    }
    
}
