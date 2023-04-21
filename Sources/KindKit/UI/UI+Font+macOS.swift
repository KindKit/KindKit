//
//  KindKit
//

#if os(macOS)

import AppKit

public extension UI.Font {
    
    init(
        weight: Weight,
        size: Double = UI.Font.systemSize
    ) {
        self.native = NSFont.systemFont(
            ofSize: CGFloat(size),
            weight: weight.nsFontWeight
        )
    }
    
    init(
        descriptor: NSFontDescriptor,
        size: Double = UI.Font.systemSize
    ) {
        self.native = NSFont(
            descriptor: descriptor,
            size: size
        )!
    }
    
}

public extension UI.Font {
    
    static var systemSize: Double {
        return Double(NSFont.systemFontSize)
    }
    
}


#endif
