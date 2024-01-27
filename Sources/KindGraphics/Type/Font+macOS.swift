//
//  KindKit
//

#if os(macOS)

import AppKit

public typealias NativeFont = NSFont

public extension Font {
    
    init(
        weight: FontWeight,
        size: Double = Font.systemSize
    ) {
        self.native = NSFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.nsFontWeight
        )
    }
    
    init(
        flags: TextFlags,
        family: FontFamily?,
        weight: FontWeight?,
        size: Double
    ) {
        var fontAttributes: [NSFontDescriptor.AttributeName : Any] = [
            .size : size
        ]
        switch family {
        case .system:
            let systemFont = NSFont.systemFont(ofSize: size)
            fontAttributes[.family] = systemFont.familyName
        case .custom(let family):
            fontAttributes[.family] = family
        case .none:
            break
        }
        var traits: [NSFontDescriptor.TraitKey : Any] = [:]
        var symbolic = NSFontDescriptor.SymbolicTraits()
        if flags.contains(.italic) {
            symbolic = symbolic.union(.italic)
        }
        if flags.contains(.bold) {
            symbolic = symbolic.union(.bold)
        }
        if symbolic.isEmpty == false {
            traits[.symbolic] = symbolic.rawValue
        }
        if let weight = weight {
            traits[.weight] = CGFloat(weight.value)
        }
        if traits.isEmpty == false {
            fontAttributes[.traits] = traits
        }
        let descriptor = NSFontDescriptor(fontAttributes: fontAttributes)
        self.native = NSFont(descriptor: descriptor, size: size)!
    }
    
}

public extension Font {
    
    static var systemSize: Double {
        return .init(NSFont.systemFontSize)
    }
    
}


#endif
