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
    
    @available(*, deprecated, renamed: "UI.Size.Dynamic.Dimension.parent")
    static func percent(_ value: Percent) -> Self {
        return .parent(value)
    }
    
    @available(*, deprecated, renamed: "UI.Size.Dynamic.Dimension.content")
    static func morph(_ value: Percent) -> Self {
        return .content(value)
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
