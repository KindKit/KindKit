//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Text.Alignment {
    
    var nsTextAlignment: NSTextAlignment {
        switch self {
        case .natural: return .natural
        case .left: return .left
        case .center: return .center
        case .right: return .right
        case .justified: return .justified
        }
    }
    
    init(_ nsTextAlignment: NSTextAlignment) {
        switch nsTextAlignment {
        case .natural: self = .natural
        case .left: self = .left
        case .center: self = .center
        case .right: self = .right
        case .justified: self = .justified
        @unknown default:
            fatalError()
        }
    }
    
}

#endif
