//
//  KindKitView
//

import KindKitCore
import KindKitMath

#if os(macOS)

import AppKit

public struct Image {

    public var native: NSImage
    public var size: SizeFloat
    
    @inlinable
    public init(
        name: String
    ) {
        guard let image = NSImage(named: name) else {
            fatalError("Not found image with '\(name)'")
        }
        self.native = image
        self.size = SizeFloat(image.size)
    }
    
    @inlinable
    public init(
        _ native: NSImage
    ) {
        self.native = native
        self.size = SizeFloat(native.size)
    }
    
}

#endif
