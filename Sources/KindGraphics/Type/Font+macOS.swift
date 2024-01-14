//
//  KindKit
//

#if os(macOS)

import AppKit

public extension Font {
    
    init(
        weight: Weight,
        size: Double = Font.systemSize
    ) {
        self.native = NSFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.nsFontWeight
        )
    }
    
    init(
        descriptor: NSFontDescriptor,
        size: Double = Font.systemSize
    ) {
        self.native = NSFont(
            descriptor: descriptor,
            size: size
        )!
    }
    
}

public extension Font {
    
    static var systemSize: Double {
        return Double(NSFont.systemFontSize)
    }
    
}


#endif
