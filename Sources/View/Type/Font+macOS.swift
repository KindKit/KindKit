//
//  KindKitView
//

#if os(OSX)

import AppKit
import KindKitCore

public struct Font {

    public var native: NSFont
    
    @inlinable
    public init(
        weight: FontWeight,
        size: Float
    ) {
        self.native = NSFont.systemFont(ofSize: CGFloat(size), weight: weight.nsFontWeight)
        
    }
    
    @inlinable
    public init(
        _ native: NSFont
    ) {
        self.native = native
    }
    
}

public extension FontWeight {
    
    var nsFontWeight: NSFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
    
    init(_ nsFontWeight: NSFont.Weight) {
        switch nsFontWeight {
        case .ultraLight: self = .ultraLight
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
