//
//  KindKitGraphics
//

import Foundation

public enum GraphicsCanvasGesture : CaseIterable {
    case one
    case two
    case three
    case four
    case five
}

public extension GraphicsCanvasGesture {
    
    var numberOfTouches: Int {
        switch self {
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        }
    }
    
}
