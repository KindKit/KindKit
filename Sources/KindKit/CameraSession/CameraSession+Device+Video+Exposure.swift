//
//  KindKit
//

import Foundation
import AVFoundation

public extension CameraSession.Device.Video {
    
    enum Exposure {
        
        case locked
        case auto
        case continuous
#if os(iOS)
        case custom(duration: CMTime, iso: Double)
#endif
        
    }
    
}

extension CameraSession.Device.Video.Exposure {
    
    var raw: AVCaptureDevice.ExposureMode {
        switch self {
        case .locked: return .locked
        case .auto: return .autoExpose
        case .continuous: return .continuousAutoExposure
#if os(iOS)
        case .custom: return .custom
#endif
        }
    }
    
    init?(_ device: AVCaptureDevice) {
        switch device.exposureMode {
        case .locked: self = .locked
        case .autoExpose: self = .auto
        case .continuousAutoExposure: self = .continuous
#if os(macOS)
        case .custom: return nil
#elseif os(iOS)
        case .custom: self = .custom(duration: device.exposureDuration, iso: Double(device.iso))
#endif
        @unknown default: return nil
        }
    }
    
    func apply(_ device: AVCaptureDevice) {
        switch self {
        case .locked: device.exposureMode = .locked
        case .auto: device.exposureMode = .autoExpose
        case .continuous: device.exposureMode = .continuousAutoExposure
#if os(iOS)
        case .custom(let duration, let iso):
            device.exposureMode = .custom
            device.setExposureModeCustom(
                duration: max(device.activeFormat.minExposureDuration, min(duration, device.activeFormat.maxExposureDuration)),
                iso: max(device.activeFormat.minISO, min(Float(iso), device.activeFormat.maxISO))
            )
#endif
        }
    }
    
}

public extension CameraSession.Device.Video {
    
    func isExposureSupported(_ feature: Exposure) -> Bool {
        return self.device.isExposureModeSupported(feature.raw)
    }
    
    func exposure() -> Exposure? {
        return .init(self.device)
    }
    
}

public extension CameraSession.Device.Video.Configuration {
    
    func isExposureSupported(_ feature: CameraSession.Device.Video.Exposure) -> Bool {
        return self.device.isExposureSupported(feature)
    }
    
    func exposure() -> CameraSession.Device.Video.Exposure? {
        return self.device.exposure()
    }
    
    func set(exposure: CameraSession.Device.Video.Exposure) {
        exposure.apply(self.device.device)
    }
    
}
