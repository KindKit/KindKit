//
//  KindKit
//

import Foundation

public extension UI {
    
    enum CornerRadius : Equatable {
        
        case none
        case auto(percent: PercentFloat, edges: Edge)
        case manual(radius: Float, edges: Edge)
        
    }
    
}

public extension UI.CornerRadius {
    
    static var auto: Self {
        return .auto(percent: .half, edges: .all)
    }
    
}

public extension UI.CornerRadius {
    
    static func manual(radius: Float) -> Self {
        return .manual(radius: radius, edges: .all)
    }
    
}
