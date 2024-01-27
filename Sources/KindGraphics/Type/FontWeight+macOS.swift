//
//  KindKit
//

#if os(macOS)

import AppKit

public extension FontWeight {
    
    var nsFontWeight: NSFont.Weight {
        return .init(.init(self.value / 1000))
    }
    
    init(_ nsFontWeight: NSFont.Weight) {
        switch nsFontWeight {
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
