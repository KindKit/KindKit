//
//  KindKit
//

public extension DragAndDrop {
    
    enum Operation {
        
        case cancel
        case forbidden
        case copy
        case move
        
    }
    
}

#if os(iOS)

import UIKit

public extension DragAndDrop.Operation {
    
    var uiDropOperation: UIDropOperation {
        switch self {
        case .cancel: return .cancel
        case .forbidden: return .forbidden
        case .copy: return .copy
        case .move: return .move
        }
    }
    
    init?(_ operation: UIDropOperation) {
        switch operation {
        case .cancel: self = .cancel
        case .forbidden: self = .forbidden
        case .copy: self = .copy
        case .move: self = .move
        @unknown default: return nil
        }
    }
    
}

#endif
