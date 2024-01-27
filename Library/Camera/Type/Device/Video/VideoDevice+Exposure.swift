//
//  KindKit
//

import AVFoundation

public extension VideoDevice {
    
    enum Exposure {
        
        case locked
        case auto
        case continuous
#if os(iOS)
        case custom(duration: CMTime, iso: Double)
#endif
        
    }
    
}

extension VideoDevice.Exposure : Hashable {
}

extension VideoDevice.Exposure : Equatable {
}

extension VideoDevice.Exposure : Sendable {
}

public extension VideoDevice {
    
    func isExposureSupported(_ feature: Exposure) -> Bool {
        return self.handle.isExposureModeSupported(feature.raw)
    }
    
    func exposure() -> Exposure? {
        return .init(self.handle)
    }
    
}

public extension VideoDevice.Configuration {
    
    func isExposureSupported(_ feature: VideoDevice.Exposure) -> Bool {
        return self.device.isExposureSupported(feature)
    }
    
    func exposure() -> VideoDevice.Exposure? {
        return self.device.exposure()
    }
    
    func set(exposure: VideoDevice.Exposure) {
        exposure.apply(self.device.handle)
    }
    
}

extension VideoDevice.Exposure {
    
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
