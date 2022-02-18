//
//  KindKitView
//

#if os(iOS)

import UIKit

public struct Font : Equatable {

    public var native: UIFont
    
    @inlinable
    public init(
        weight: FontWeight,
        size: Float
    ) {
        self.native = UIFont.systemFont(ofSize: CGFloat(size), weight: weight.uiFontWeight)
        
    }
    
    @inlinable
    public init(
        name: String,
        size: Float
    ) {
        self.native = UIFont(name: name, size: CGFloat(size))!
    }
    
    @inlinable
    public init(
        _ native: UIFont
    ) {
        self.native = native
    }
    
}

public extension Font {
    
    @inlinable
    var lineHeight: Float {
        return Float(self.native.lineHeight)
    }
    
    @inlinable
    func withSize(_ size: Float) -> Font {
        return Font(self.native.withSize(CGFloat(size)))
    }
    
}

public extension FontWeight {
    
    var uiFontWeight: UIFont.Weight {
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
    
    init(_ uiFontWeight: UIFont.Weight) {
        switch uiFontWeight {
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
