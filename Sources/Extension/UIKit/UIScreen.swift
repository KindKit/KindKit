//
//  KindKit
//

#if os(iOS)

import UIKit

public extension UIScreen {
    
    static let kk_diagonalInInches: Float = {
        let bounds = UIScreen.main.nativeBounds
        let diagonal = Float(sqrt((bounds.width * bounds.width) + (bounds.height * bounds.height)))
        let ppi = Float(UIScreen.kk_pixelPerInch)
        return diagonal / ppi
    }()
    
    static let kk_animationVelocity: Float = {
        let bounds = UIScreen.main.bounds
        let size = Float(max(bounds.width, bounds.height))
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return size * 2.2
        case .pad: return size * 2.5
        default: return 100
        }
    }()
    
    static let kk_pixelPerInch: Float = {
        let device = UIDevice.current
        let screen = UIScreen.main
        switch device.userInterfaceIdiom {
        case .phone:
            if let ppi = UIScreen._iPhonePpi(machine: UIDevice.kk_identifier) {
                return ppi
            }
            return screen.scale == 2 ? 264 : 132
        case .pad:
            if let ppi = UIScreen._iPadPpi(machine: UIDevice.kk_identifier) {
                return ppi
            }
            if screen.scale == 3 {
                return screen.nativeScale == 3 ? 458 : 401
            }
            return 326
        default:
            return 160 * Float(screen.scale)
        }
    }()
    
}

fileprivate extension UIScreen {
    
    static func _iPhonePpi(machine: String) -> Float? {
        switch machine {
        case "iPhone14,4": fallthrough // iPhone 13 mini
        case "iPhone13,1":             // iPhone 12 mini
            return 476
        case "iPhone14,7": fallthrough // iPhone 14
        case "iPhone15,2": fallthrough // iPhone 14 Pro
        case "iPhone15,3": fallthrough // iPhone 14 Pro Max
        case "iPhone14,5": fallthrough // iPhone 13
        case "iPhone14,2": fallthrough // iPhone 13 Pro
        case "iPhone13,2": fallthrough // iPhone 12
        case "iPhone13,3":             // iPhone 12 Pro
            return 460
        case "iPhone14,8": fallthrough // iPhone 14 Plus
        case "iPhone14,3": fallthrough // iPhone 13 Pro Max
        case "iPhone13,4": fallthrough // iPhone 12 Pro Max
        case "iPhone12,3": fallthrough // iPhone 11 Pro
        case "iPhone12,5": fallthrough // iPhone 11 Pro Max
        case "iPhone11,2": fallthrough // iPhone XS
        case "iPhone11,4", "iPhone11,6": fallthrough // iPhone XS Max
        case "iPhone10,3", "iPhone10,6": // iPhone X
            return 458
        case "iPhone10,2", "iPhone10,5": fallthrough // iPhone 8 Plus
        case "iPhone9,2", "iPhone9,4": fallthrough // iPhone 7 Plus
        case "iPhone8,2": fallthrough // iPhone 6S Plus
        case "iPhone7,1": // iPhone 6 Plus
            return 401
        case "iPhone12,1": fallthrough // iPhone 11
        case "iPhone11,8": fallthrough // iPhone XR
        case "iPhone14,6": fallthrough // iPhone SE (3rd generation)
        case "iPhone12,8": fallthrough // iPhone SE (2nd generation)
        case "iPhone10,1", "iPhone10,4": fallthrough // iPhone 8
        case "iPhone9,1", "iPhone9,3": fallthrough // iPhone 7
        case "iPhone8,1": fallthrough // iPhone 6S
        case "iPhone7,2": fallthrough // iPhone 6
        case "iPhone8,4": fallthrough // iPhone SE
        case "iPhone6,1", "iPhone6,2": fallthrough // iPhone 5S
        case "iPhone5,3", "iPhone5,4": fallthrough // iPhone 5C
        case "iPhone5,1", "iPhone5,2": fallthrough // iPhone 5
        case "iPhone4,1": // iPhone 4S
            return 326
        case "iPod9,1": fallthrough // iPod touch (7th generation)
        case "iPod7,1": fallthrough // iPod touch (6th generation)
        case "iPod5,1": // iPod touch (5th generation)
            return 326
        default:
            return nil
        }
    }
    
    static func _iPadPpi(machine: String) -> Float? {
        switch machine {
        case "iPad14,1", "iPad14,2": fallthrough // iPad mini (6th generation)
        case "iPad11,1", "iPad11,2": fallthrough // iPad mini (5th generation)
        case "iPad5,1", "iPad5,2": fallthrough // iPad mini 4
        case "iPad4,7", "iPad4,8", "iPad4,9": fallthrough // iPad mini 3
        case "iPad4,4", "iPad4,5", "iPad4,6": // iPad mini 2
            return 326
        case "iPad13,16", "iPad13,17": fallthrough // iPad Air (5th generation)
        case "iPad12,1", "iPad12,2": fallthrough // iPad (9th generation)
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": fallthrough // iPad Pro (12.9″, 5th generation)
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": fallthrough // iPad Pro (11″, 3rd generation)
        case "iPad13,1", "iPad13,2": fallthrough // iPad Air (4th generation)
        case "iPad11,6", "iPad11,7": fallthrough // iPad (8th generation)
        case "iPad8,11", "iPad8,12": fallthrough // iPad Pro (12.9″, 4th generation)
        case "iPad8,9", "iPad8,10": fallthrough // iPad Pro (11″, 2nd generation)
        case "iPad7,11", "iPad7,12": fallthrough // iPad (7th generation)
        case "iPad11,3", "iPad11,4": fallthrough // iPad Air (3rd generation)
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": fallthrough // iPad Pro (12.9″, 3rd generation)
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": fallthrough // iPad Pro (11″)
        case "iPad7,5", "iPad7,6": fallthrough // iPad (6th generation)
        case "iPad7,3", "iPad7,4": fallthrough // iPad Pro (10.5″)
        case "iPad7,1", "iPad7,2": fallthrough // iPad Pro (12.9″, 2nd generation)
        case "iPad6,11", "iPad6,12": fallthrough // iPad (5th generation)
        case "iPad6,7", "iPad6,8": fallthrough // iPad Pro (12.9″)
        case "iPad6,3", "iPad6,4": fallthrough // iPad Pro (9.7″)
        case "iPad5,3", "iPad5,4": fallthrough // iPad Air 2
        case "iPad4,1", "iPad4,2", "iPad4,3": fallthrough // iPad Air
        case "iPad3,4", "iPad3,5", "iPad3,6": fallthrough // iPad (4th generation)
        case "iPad3,1", "iPad3,2", "iPad3,3": // iPad (3rd generation)
            return 264
        case "iPad2,5", "iPad2,6", "iPad2,7": // iPad mini
            return 163
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": // iPad 2
            return 132
        default:
            return nil
        }
    }
    
}


#endif
