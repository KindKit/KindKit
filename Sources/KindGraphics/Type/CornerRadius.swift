//
//  KindKit
//

import KindMath

public enum CornerRadius : Equatable {
    
    case none
    case auto(percent: Percent, edges: Edge)
    case manual(radius: Double, edges: Edge)
    
}

public extension CornerRadius {
    
    static var auto: Self {
        return .auto(percent: .half, edges: .all)
    }
    
}

public extension CornerRadius {
    
    static func manual(radius: Double) -> Self {
        return .manual(radius: radius, edges: .all)
    }
    
}
