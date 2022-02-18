//
//  KindKitView
//

#if os(iOS)

import UIKit

public extension TextWritingDirection {
    
    var nsWritingDirection: NSWritingDirection {
        switch self {
        case .natural: return .natural
        case .leftToRight: return .leftToRight
        case .rightToLeft: return .rightToLeft
        }
    }
    
    init(_ nsWritingDirection: NSWritingDirection) {
        switch nsWritingDirection {
        case .natural: self = .natural
        case .leftToRight: self = .leftToRight
        case .rightToLeft: self = .rightToLeft
        @unknown default:
            fatalError()
        }
    }
    
}

#endif
