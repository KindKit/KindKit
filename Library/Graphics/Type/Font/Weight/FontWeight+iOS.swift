//
//  KindKit
//

#if os(iOS)

import UIKit

public extension FontWeight {
    
    var uiFontWeight: UIFont.Weight {
        return .init(.init(self.value / 1000))
    }
    
    init(_ uiFontWeight: UIFont.Weight) {
        switch uiFontWeight {
        case .ultraLight: self = .ultralight
        case .thin: self = .thin
        case .light: self = .light
        case .regular: self = .regular
        case .medium: self = .medium
        case .semibold: self = .semibold
        case .bold: self = .bold
        case .heavy: self = .heavy
        case .black: self = .black
        default: fatalError()
        }
    }
    
}

#endif
