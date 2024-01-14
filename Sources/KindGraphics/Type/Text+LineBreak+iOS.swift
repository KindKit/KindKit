//
//  KindKit
//

#if os(iOS)

import UIKit

public extension Text.LineBreak {

    var nsLineBreakMode: NSLineBreakMode {
        switch self {
        case .cliping: return .byClipping
        case .wordWrapping: return .byWordWrapping
        case .charWrapping: return .byCharWrapping
        case .truncatingHead: return .byTruncatingHead
        case .truncatingMiddle: return .byTruncatingMiddle
        case .truncatingTail: return .byTruncatingTail
        }
    }
    
    init(_ nsLineBreakMode: NSLineBreakMode) {
        switch nsLineBreakMode {
        case .byClipping: self = .cliping
        case .byWordWrapping: self = .wordWrapping
        case .byCharWrapping: self = .charWrapping
        case .byTruncatingHead: self = .truncatingHead
        case .byTruncatingMiddle: self = .truncatingMiddle
        case .byTruncatingTail: self = .truncatingTail
        @unknown default:
            fatalError()
        }
    }
    
}

#endif
