//
//  KindKit
//

import Foundation

public extension UI {
    
    enum Border : Equatable {
        
        case none
        case manual(
            width: Double,
            color: UI.Color,
            join: Graphics.LineJoin,
            dash: Graphics.LineDash?
        )
        
    }
    
}

public extension UI.Border {
    
    static func manual(width: Double, color: UI.Color) -> Self {
        return .manual(width: width, color: color, join: .round, dash: nil)
    }
    
}
