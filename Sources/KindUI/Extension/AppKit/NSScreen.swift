//
//  KindKit
//

#if os(macOS)

import AppKit

public extension NSScreen {
    
    static var kk_animationVelocity: Double = {
        guard let screen = NSScreen.main else {
            return 2000
        }
        let frame = screen.frame
        let size = Double(max(frame.width, frame.height))
        return size * 2
    }()
    
    static var kk_diagonalInInches: Double = {
        return NSScreen.main?.kk_diagonalInInches ?? 1
    }()
    
    static var kk_pixelPerInch: Double = {
        return NSScreen.main?.kk_pixelPerInch ?? 72
    }()
    
    var kk_diagonalInInches: Double {
        let frame = self.frame
        let diagonal = Double(sqrt((frame.width * frame.width) + (frame.height * frame.height)))
        let ppi = self.kk_pixelPerInch
        return diagonal / ppi
    }
    
    var kk_pixelPerInch: Double {
        let description = self.deviceDescription
        guard let screenNumber = (description[.kk_number] as? NSNumber)?.uint32Value else {
            return 72
        }
        guard let pixelSize = (description[.size] as? NSValue)?.sizeValue else {
            return 72
        }
        let physicalSize = CGDisplayScreenSize(screenNumber)
        return (pixelSize.width / physicalSize.width) * 25.4
    }
    
}

public extension NSDeviceDescriptionKey {
    
    static let kk_number = NSDeviceDescriptionKey("NSScreenNumber")
    
}

#endif
