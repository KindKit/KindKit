//
//  KindKit
//

#if os(iOS)

import UIKit

public typealias NativeFont = UIFont

public extension Font {
    
    init(
        weight: FontWeight,
        size: Double = Font.systemSize
    ) {
        self.native = UIFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.uiFontWeight
        )
    }
    
    init(
        weight: FontWeight,
        scaled: Double = Font.systemSize,
        lower: Double? = nil,
        upper: Double? = nil
    ) {
        self.init(
            weight: weight,
            size: Self.scaled(
                size: scaled,
                lower: lower,
                upper: upper
            )
        )
    }
    
    init?(
        name: String,
        size: Double = Font.systemSize
    ) {
        guard let font = UIFont(name: name, size: .init(size)) else {
            return nil
        }
        self.native = font
    }
    
    init?(
        name: String,
        scaled: Double = Font.systemSize,
        lower: Double? = nil,
        upper: Double? = nil
    ) {
        self.init(
            name: name,
            size: Self.scaled(
                size: scaled,
                lower: lower,
                upper: upper
            )
        )
    }
    
    init(
        flags: TextFlags,
        family: FontFamily?,
        weight: FontWeight?,
        size: Double
    ) {
        var fontAttributes: [UIFontDescriptor.AttributeName : Any] = [
            .size : size
        ]
        switch family {
        case .system:
            let systemFont = UIFont.systemFont(ofSize: size)
            fontAttributes[.family] = systemFont.familyName
        case .custom(let family):
            fontAttributes[.family] = family
        case .none:
            break
        }
        var traits: [UIFontDescriptor.TraitKey : Any] = [:]
        var symbolic = UIFontDescriptor.SymbolicTraits()
        if flags.contains(.italic) {
            symbolic = symbolic.union(.traitItalic)
        }
        if flags.contains(.bold) {
            symbolic = symbolic.union(.traitBold)
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
        let descriptor = UIFontDescriptor(fontAttributes: fontAttributes)
        self.native = UIFont(descriptor: descriptor, size: size)
    }
    
    init(
        flags: TextFlags,
        family: FontFamily?,
        weight: FontWeight?,
        scaled: Double,
        lower: Double? = nil,
        upper: Double? = nil
    ) {
        self.init(
            flags: flags,
            family: family,
            weight: weight,
            size: Self.scaled(
                size: scaled,
                lower: lower,
                upper: upper
            )
        )
    }
    
}

public extension Font {
    
    static var systemSize: Double {
        return .init(UIFont.systemFontSize)
    }
    
    static func scaled(
        size: Double,
        lower: Double? = nil,
        upper: Double? = nil
    ) -> Double {
        var size = Double(UIFontMetrics.default.scaledValue(for: .init(size)))
        if let lower = lower {
            size = max(lower, size)
        }
        if let upper = upper {
            size = min(size, upper)
        }
        return size
    }
    
}

public extension Font {
    
    @inlinable
    var lineHeight: Double {
        return .init(self.native.lineHeight)
    }
    
    @inlinable
    func withSize(_ size: Double) -> Font {
        return .init(self.native.withSize(.init(size)))
    }
    
}

#endif
